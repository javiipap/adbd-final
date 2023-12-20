from flask import Blueprint, request, jsonify, abort
from marshmallow import ValidationError

from ...db import get_cursor
from ...validators import LuxuryFeeSchema

luxury_fees = Blueprint('luxury_fees', __name__,
                        url_prefix='/<int:airline_id>/luxury_fees')


@luxury_fees.route('', methods=['GET', 'POST', 'DELETE', 'PUT'])
def list_luxury_fees(airline_id):
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute(
            'SELECT * FROM seat_luxury_fees WHERE airline_id = %s;', (airline_id, ))
        output = cursor.fetchall()
        return jsonify(output)
    elif request.method == 'POST':
        user_data = request.json

        try:
            LuxuryFeeSchema().load(user_data)
        except ValidationError as e:
            abort(400, e.messages)

        cursor = get_cursor()
        cursor.execute('INSERT INTO seat_luxury_fees (airline_id, description, fee, id, luxury_type) VALUES (%s, %s, %s, %s, %s);',
                       (airline_id, user_data['description'], user_data['fee'], airline_id, user_data['luxury_type']))

        return jsonify({'message': 'Airline luxury fee created successfully'}), 201
    elif request.method == 'DELETE':
        cursor = get_cursor()
        user_data = request.json
        luxury_type_to_delete = user_data.get('luxury_type')

        if luxury_type_to_delete is None:
            return abort(400, 'Luxury type parameter is required for deletion')

        cursor.execute(
            'DELETE FROM seat_luxury_fees WHERE luxury_type = %s;', (luxury_type_to_delete, ))

        return jsonify({'message': 'Airline luxury fees deleted successfully'}), 200
    elif request.method == 'PUT':
        cursor = get_cursor()
        user_data = request.json

        try:
            LuxuryFeeSchema().load(user_data)
        except ValidationError as e:
            abort(400, e.messages)

        cursor.execute('UPDATE seat_luxury_fees SET description = %s, fee = %s, luxury_type = %s WHERE airline_id = %s;',
                       (user_data['description'], user_data['fee'], user_data['luxury_type']))

        return jsonify({'message': 'Airline luxury fees updated successfully'}), 200
