from flask import Blueprint, request, jsonify, abort
from ...db import get_db, get_cursor
from ...validators import FlightSchema
from marshmallow import ValidationError

flights = Blueprint('flights', __name__,
                    url_prefix='/<int:airline_id>/flights')


@flights.route('', methods=['GET', 'POST'])
def hello(airline_id):
    cursor = get_cursor()

    if request.method == 'GET':
        cursor.execute(
            'SELECT f.arrival_date,'
            '       f.departure_date,'
            '       f.duration,'
            '       f.flight_number,'
            '       a.name as airline_name,'
            '       a1.iata as origin_airport,'
            '       a2.iata as destination_airport '
            'FROM flights f '
            'INNER JOIN AIRLINES a '
            'ON a.id = airline_id '
            'INNER JOIN AIRPORTS a1 '
            'ON a1.id = origin_id '
            'INNER JOIN AIRPORTS a2 '
            'ON a2.id = destination_id '
            'WHERE airline_id = %s',
            (airline_id, ))
        raw = cursor.fetchall()

        parsed = [{
            "airline_name": fl['airline_name'],
            "schedule": {
                "arrival_date": fl['arrival_date'],
                "departure_date": fl['departure_date'],
                "duration": fl['duration']
            },
            "destination_airport": fl['destination_airport'],
            "origin_airport": fl['origin_airport'],
            "flight_number": fl['flight_number']
        } for fl in raw]

        return jsonify(parsed)

    body = request.get_json()

    try:
        _ = FlightSchema().load(body)
    except ValidationError as e:
        abort(400, e.messages)

    db = get_db()
    cursor = db.cursor()

    cursor.execute(
        'INSERT INTO flights (airline_id, origin_id, destination_id, departure_date, arrival_date, duration, flight_number) '
        'VALUES (%s, %s, %s, %s, %s, %s, %s)'
        'RETURNING id',
        (airline_id, body['origin_id'], body['destination_id'], body['departure_date'], body['arrival_date'], body['duration'], body['flight_number']))

    flight_id = cursor.fetchone()

    if not flight_id:
        abort(500, 'Failed to create flight')

    for seat in body['seats']:
        cursor.execute(
            'INSERT INTO seats (flight_id, col, row, luxury_id) '
            'VALUES (%s, %s, %s)',
            (flight_id, seat['col'], seat['row'], seat['luxury_id']))

    db.commit()

    return jsonify({'flight_id': flight_id[0]}), 201
