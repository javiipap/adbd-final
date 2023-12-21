from flask import Blueprint, request, jsonify, abort
from marshmallow import ValidationError
from ..db import get_db, get_cursor
from ..validators import BookingSchema
from collections import defaultdict
import json

bookings = Blueprint('bookings', __name__, url_prefix='/bookings')

base_query = """
SELECT b.id booking_id,
       f.id flight_id,
       s.id seat_id,
       s.col,
       s.row,
       array_to_string(array_agg(DISTINCT c.id), \':\') luggage_ids,
       array_to_string(array_agg(DISTINCT c.weight), \':\') luggage_weights,
       b.date booking_date,
       f.departure_date departure_date,
       f.arrival_date arrival_date,
       s.price,
       s.user_info,
       cl.id cancelation_id
FROM bookings b
LEFT JOIN cancelations cl
ON cl.booking_id = b.id
INNER JOIN seats s
ON b.seat_id = s.id
INNER JOIN flights f
ON s.flight_number = f.flight_number AND s.airline_id = f.airline_id
INNER JOIN cargo c
ON c.seat_id = s.id
GROUP BY b.id, f.id, s.id, s.col, s.row, s.id, b.date, f.departure_date, f.arrival_date, s.price, s.user_info, cl.id"""


def parse_bookings(raw_bookings):
    parsed = defaultdict(dict)
    cursor = get_cursor()

    for booking in raw_bookings:
        if booking['booking_id'] not in parsed:
            cursor.execute('SELECT "calculate_discounted_booking_price"(%s),'
                           '       "calculate_booking_price"(%s)',
                           [booking['booking_id'], booking['booking_id']])
            prices = cursor.fetchone()

            parsed[booking['booking_id']] = {
                'booking_date': booking['booking_date'],
                'flight_id': booking['flight_id'],
                'departure_date': booking['departure_date'],
                'arrival_date': booking['arrival_date'],
                'seats': [],
                'price_raw': prices['calculate_booking_price'],
                'price': prices['calculate_discounted_booking_price'],
                'canceled': booking['cancelation_id'] is None
            }

        parsed[booking['booking_id']]['seats'].append({
            'seat_id': booking['seat_id'],
            'position': {
                'col': booking['col'],
                'row': booking['row'],
            },
            'price': booking['price'],
            'user_info': booking['user_info'],
            'luggage': [{'id': l_id, 'weight': l_weight} for l_id, l_weight in zip(booking['luggage_ids'].split(':'), booking['luggage_weights'].split(':'))]
        })

    return parsed


@bookings.route('', methods=['GET', 'POST'])
def bookings_controller():
    db = get_db()

    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute(base_query)
        raw = cursor.fetchall()
        raw = raw if raw else []

        parsed = parse_bookings(raw)

        return jsonify([{'booking_id': k, **v} for k, v in parsed.items()])

    body = request.get_json()

    try:
        _ = BookingSchema().load(body)
    except ValidationError as err:
        abort(400, err.messages)

    user_id = body.get('user_id')
    flights = body.get('flights')

    booked = {flight.get('flight_id'): [] for flight in flights}

    cursor = db.cursor()
    for flight in flights:
        flight_id = flight.get('flight_id')
        seats = flight.get('seats')

        cursor.execute(
            'SELECT flight_number, airline_id FROM flights WHERE id = %s', [flight_id])
        flight_info = cursor.fetchone()
        if not flight_info:
            abort(400, 'Invalid flight id')
        flight_number, airline_id = flight_info

        booking_id = None

        for seat in seats:
            luggage = seat.get('luggage', [])
            row = seat.get('row')
            col = seat.get('col')
            user_info = seat.get('user_info', {})

            # Check if seat exists and retrieve id
            cursor.execute('SELECT id from seats WHERE col = %s AND row = %s AND flight_number = %s AND airline_id = %s',
                           [col, row, flight_number, airline_id])
            seat_id = cursor.fetchone()

            # Check if seat is already booked
            cursor.execute('SELECT b.id FROM bookings b LEFT JOIN cancelations c ON c.booking_id = b.id AND b.seat_id = %s WHERE c.booking_id IS NULL',
                           [seat_id])
            prev_booking = cursor.fetchone()

            if prev_booking or not seat_id:
                booked[flight_id]['seats'].append({
                    'position': {
                        'row': row,
                        'col': col,
                    },
                    'flight_id': flight_id,
                    'success': False,
                    'error': 'Seat already booked' if prev_booking else 'Seat does not exist'
                })
                continue

            # Attempt to book seat
            if booking_id:
                cursor.execute('INSERT INTO bookings (id, user_id, seat_id) '
                               'SELECT %s, %s, %s '
                               'WHERE NOT EXISTS ('
                               '   SELECT id FROM bookings '
                               '   WHERE seat_id = %s)'
                               'RETURNING id',
                               [booking_id, user_id, seat_id, seat_id])
            else:
                cursor.execute('INSERT INTO bookings (user_id, seat_id) '
                               'SELECT %s, %s '
                               'WHERE NOT EXISTS ('
                               '   SELECT id FROM bookings '
                               '   WHERE seat_id = %s)'
                               'RETURNING id',
                               [user_id, seat_id, seat_id])
                booking_id = cursor.fetchone()

            if not booking_id:
                booked[flight_id]['seats'].append({
                    'position': {
                        'row': row,
                        'col': col,
                    },
                    'flight_id': flight_id,
                    'success': False,
                    'error': 'Seat already booked'
                })
                continue
            booking_id = booking_id[0]

            # Update seat info
            cursor.execute('UPDATE seats SET user_info = %s WHERE id = %s',
                           [json.dumps(user_info), seat_id])

            # Store luggage info
            inserted_luggage = []
            for l in luggage:
                cursor.execute(
                    'INSERT INTO cargo (seat_id, flight_number, airline_id, weight) '
                    'VALUES (%s, %s, %s, %s) '
                    'RETURNING id',
                    [seat_id, flight_number, airline_id, l.get('weight')])
                luggage_id = cursor.fetchone()
                inserted_luggage.append(
                    {'id': luggage_id[0], 'weight': l.get('weight')})

            booked[flight_id]['booking_id'] = booking_id
            booked[flight_id]['seats'].append({
                'position': {
                    'row': row,
                    'col': col,
                },
                'success': True,
                'luggage': inserted_luggage
            })

            db.commit()

    cursor.close()

    return jsonify([{'flight_id': k, 'info': v} for k, v in booked.items()])


@bookings.route('/<int:booking_id>', methods=['GET', 'DELETE'])
def booking(booking_id):
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute(base_query.replace(
            'GROUP BY', 'WHERE b.id = %s GROUP BY '), [booking_id])
        raw = cursor.fetchall()
        raw = raw if raw else []

        parsed = parse_bookings(raw)

        return jsonify([{'booking_id': k, **v} for k, v in parsed.items()][0])
    elif request.method == 'DELETE':
        cursor = get_cursor()
        cursor.execute('DELETE FROM bookings WHERE id = %s', [booking_id])

        return jsonify({"message": f"Booking {booking_id} deleted"})


@bookings.route('/<int:booking_id>/cancel', methods=['POST'])
def cancel_booking(booking_id):
    cursor = get_cursor()
    cursor.execute('INSERT INTO cancelations (booking_id) VALUES (%s)',
                   [booking_id])

    return jsonify({"message": f"Booking {booking_id} canceled"})
