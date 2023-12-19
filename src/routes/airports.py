from flask import Blueprint, jsonify, request

from ..db import get_cursor

airports = Blueprint('airports', __name__, url_prefix='/airports')


@airports.route('', methods=['GET', 'POST'])
def hello():
    # return 'Hello, airports!'
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT name, country, city, iata FROM airports;')
        output = cursor.fetchall()
        return jsonify(output)

    if request.method == 'POST':
        airport_data = request.json
        cursor = get_cursor()

        required_fields = ['name', 'country','city','iata']
        if not all(field in airport_data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        cursor = get_cursor()
        cursor.execute('INSERT INTO airports (name, country, city, iata) VALUES (%s, %s, %s, %s);',
                       (airport_data['name'], airport_data['country'], airport_data['city'], airport_data['iata']))

        cursor.connection.commit()
        cursor.close()

        return jsonify({'message': 'Airport created successfully'}), 201
