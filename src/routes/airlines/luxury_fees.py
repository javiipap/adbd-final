from flask import Blueprint, request, jsonify
from ...db import get_cursor

luxury_fees = Blueprint('luxury_fees', __name__,
                        url_prefix='/<int:airline_id>/luxury_fees')


@luxury_fees.route('', methods=['GET', 'POST'])
def list_luxury_fees(airline_id):
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT * FROM seat_luxury_fees WHERE airline_id = %s;', (airline_id, ))
        output = cursor.fetchall()
        return jsonify(output) 
    if request.method == 'POST':
        user_data = request.json
        cursor = get_cursor()

        required_fields = ['description', 'fee', 'luxury_type']
        if not all(field in user_data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        cursor = get_cursor()
        cursor.execute('INSERT INTO seat_luxury_fees (airline_id, description, fee, id, luxury_type) VALUES (%s, %s, %s, %s, %s);',
                       (airline_id, user_data['description'], user_data['fee'], airline_id, user_data['luxury_type']))

        cursor.connection.commit()
        cursor.close()

        return jsonify({'message': 'Airline luxury fee created successfully'}), 201
