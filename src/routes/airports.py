from flask import Blueprint, jsonify, request, abort
from marshmallow import ValidationError

from ..db import get_cursor
from ..validators import AirportSchema

airports = Blueprint('airports', __name__, url_prefix='/airports')


@airports.route('', methods=['GET', 'POST'])
def list_airport():
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT name, country, city, iata FROM airports;')
        output = cursor.fetchall()
        return jsonify(output)
    elif request.method == 'POST':
        airport_data = request.json
        cursor = get_cursor()

        try:
            AirportSchema().load(airport_data)
        except ValidationError as e:
            abort(400, e.messages)

        cursor.execute('INSERT INTO airports (name, country, city, iata) VALUES (%s, %s, %s, %s);',
                       (airport_data['name'], airport_data['country'], airport_data['city'], airport_data['iata']))

        return jsonify({'message': 'Airport created successfully'}), 201
