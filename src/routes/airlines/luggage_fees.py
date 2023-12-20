from flask import Blueprint, jsonify, request, abort
from marshmallow import ValidationError

from ...db import get_cursor
from ...validators import LuggageFeeSchema

luggage_fees = Blueprint('luggage_fees', __name__,
                         url_prefix='/<int:airline_id>/luggage_fees')


@luggage_fees.route('', methods=['GET', 'POST', 'DELETE', 'PUT'])
def list_luggage_fees(airline_id):
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute(
            'SELECT * FROM luggage_fees WHERE airline_id = %s;', (airline_id, ))
        output = cursor.fetchall()
        return jsonify(output)
    elif request.method == 'POST':
        user_data = request.json

        try:
            LuggageFeeSchema().load(user_data)
        except ValidationError as e:
            abort(400, e.messages)

        cursor = get_cursor()
        cursor.execute('INSERT INTO luggage_fees (airline_id, fee, id, weight) VALUES (%s, %s, %s, %s);',
                       (airline_id, user_data['fee'], airline_id, user_data['weight']))

        return jsonify({'message': 'Airline luggage fee created successfully'}), 201
    elif request.method == 'DELETE':
        cursor = get_cursor()
        user_data = request.json
        weight_to_delete = user_data.get('weight')

        if weight_to_delete is None:
            return jsonify({'error': 'Weight parameter is required for deletion'}), 400

        cursor.execute(
            'DELETE FROM luggage_fees WHERE weight = %s;', (weight_to_delete, ))

        return jsonify({'message': 'Airline luggage fees deleted successfully'}), 200
    elif request.method == 'PUT':
        cursor = get_cursor()
        user_data = request.json

        try:
            LuggageFeeSchema().load(user_data)
        except ValidationError as e:
            abort(400, e.messages)

        cursor.execute('UPDATE luggage_fees SET fee = %s, weight = %s WHERE airline_id = %s;',
                       (user_data['fee'], user_data['weight'], airline_id))

        return jsonify({'message': 'Airline luggage fees updated successfully'}), 200
