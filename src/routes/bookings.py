from flask import Blueprint, request, jsonify, abort
from marshmallow import ValidationError
from ..db import get_db, get_cursor
from ..models import BookingSchema
from collections import defaultdict

bookings = Blueprint('bookings', __name__, url_prefix='/bookings')


@bookings.route('', methods=['GET', 'POST'])
def hello():
    db = get_db()

    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute(
            'SELECT b.id booking_id,'
            '       f.id flight_id,'
            '       s.id seat_id,'
            '       s.col,'
            '       s.row,'
            '       array_to_string(array_agg(DISTINCT c.id), \':\') luggage_ids,'
            '       array_to_string(array_agg(DISTINCT c.weight), \':\') luggage_weights,'
            '       b.date booking_date,'
            '       f.departure_date departure_date,'
            '       f.arrival_date arrival_date,'
            '       s.price,'
            '       s.user_info '
            'FROM bookings b INNER JOIN seats s '
            'ON b.seat_id = s.id '
            'INNER JOIN flights f '
            'ON s.flight_id = f.id '
            'INNER JOIN cargo c '
            'ON c.seat_id = s.id '
            'GROUP BY b.id, f.id, s.id, s.col, s.row, s.id, b.date, f.departure_date, f.arrival_date, s.price, s.user_info')
        raw = cursor.fetchall()
        parsed = defaultdict(dict)

        for booking in raw:
            if booking['booking_id'] not in parsed:
                parsed[booking['booking_id']] = {
                    'booking_date': booking['booking_date'],
                    'flight_id': booking['flight_id'],
                    'departure_date': booking['departure_date'],
                    'arrival_date': booking['arrival_date'],
                    'seats': [],
                    'total_price': 0
                }

            parsed[booking['booking_id']
                   ]['total_price'] += booking['price']

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

        return jsonify([{'booking_id': k, 'info': v} for k, v in parsed.items()])

    body = request.get_json()

    try:
        _ = BookingSchema().load(body)
    except ValidationError as err:
        abort(400, err.messages)

    user_id = body.get('user_id')
    flights = body.get('flights')

    booked = {flight.get('flight_id'): [] for flight in flights}

    # Implementar

    return jsonify(booked)


@bookings.route('/<int:booking_id>', methods=['GET', 'DELETE'])
def reservation(booking_id):
    ...
