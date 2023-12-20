from flask import Blueprint, jsonify, request
from ...db import get_cursor

luggage_fees = Blueprint('luggage_fees', __name__,
                         url_prefix='/<int:airline_id>/luggage_fees')


@luggage_fees.route('', methods=['GET', 'POST', 'DELETE', 'PUT'])
def list_luggage_fees(airline_id):
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT * FROM luggage_fees WHERE airline_id = %s;', (airline_id, ))
        output = cursor.fetchall()
        return jsonify(output) 
    if request.method == 'POST':
        user_data = request.json
        cursor = get_cursor()

        required_fields = ['fee', 'weight']
        if not all(field in user_data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        cursor = get_cursor()
        cursor.execute('INSERT INTO luggage_fees (airline_id, fee, id, weight) VALUES (%s, %s, %s, %s);',
                       (airline_id, user_data['fee'], airline_id, user_data['weight']))

        cursor.connection.commit()
        cursor.close()

        return jsonify({'message': 'Airline luggage fee created successfully'}), 201
    if request.method == 'DELETE':
        cursor = get_cursor()
        user_data = request.json
        weight_to_delete = user_data.get('weight')

        if weight_to_delete is None:
            return jsonify({'error': 'Weight parameter is required for deletion'}), 400
        
        cursor.execute('DELETE FROM luggage_fees WHERE weight = %s;', (weight_to_delete, ))
        cursor.connection.commit()
        cursor.close()
        return jsonify({'message': 'Airline luggage fees deleted successfully'}), 200
    if request.method == 'PUT':
        cursor = get_cursor()
        user_data = request.json

        required_fields = ['fee', 'weight']
        if not all(field in user_data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        cursor.execute('UPDATE luggage_fees SET fee = %s, weight = %s WHERE airline_id = %s;',
                       (user_data['fee'], user_data['weight'], airline_id))

        cursor.connection.commit()
        cursor.close()
        return jsonify({'message': 'Airline luggage fees updated successfully'}), 200
