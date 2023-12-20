from flask import Blueprint, jsonify, request

from ..db import get_cursor

bonifications = Blueprint('bonifications', __name__,
                          url_prefix='/bonifications')


@bonifications.route('', methods=['GET', 'POST'])
def hello():
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT name, value, description, type FROM bonifications;')
        output = cursor.fetchall()
        return jsonify(output)

    if request.method == 'POST':
        bonification_data = request.json
        cursor = get_cursor()

        required_fields = ['name', 'value', 'description','type']
        if not all(field in bonification_data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        cursor = get_cursor()
        cursor.execute('INSERT INTO bonifications (name, value, description, type) VALUES (%s, %s, %s, %s);',
                       (bonification_data['name'], bonification_data['value'], bonification_data['description'], bonification_data['type']))

        cursor.connection.commit()
        cursor.close()

        return jsonify({'message': 'Bonification created successfully'}), 201
