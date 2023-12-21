from flask import Blueprint, jsonify, request, abort
from marshmallow import ValidationError

from ...db import get_cursor
from ...validators import AirlineSchema

from .flights import flights
from .luggage_fees import luggage_fees
from .luxury_fees import luxury_fees

airlines = Blueprint('airlines', __name__, url_prefix='/airlines')
airlines.register_blueprint(flights)
airlines.register_blueprint(luggage_fees)
airlines.register_blueprint(luxury_fees)


@airlines.route('', methods=['GET', 'POST'])
def list_airlines():
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT * FROM airlines;')
        output = cursor.fetchall()
        return jsonify(output)
    elif request.method == 'POST':
        user_data = request.json

        try:
            AirlineSchema().load(user_data)
        except ValidationError as e:
            abort(400, e.messages)

        cursor = get_cursor()
        cursor.execute('INSERT INTO airlines (icao, id, name) VALUES (%s, %s, %s);',
                       (user_data['icao'], user_data['id'], user_data['name']))

        return jsonify({'message': 'Airline created successfully'}), 201


@airlines.route('/<int:id>', methods=['GET'])
def airline_info(id):
    cursor = get_cursor()
    cursor.execute('SELECT * FROM airlines WHERE id = %s;', (id,))
    output = cursor.fetchone()
    return jsonify(output)
