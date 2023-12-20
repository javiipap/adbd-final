from flask import Blueprint, jsonify, request

from ..db import get_cursor

users = Blueprint('users', __name__, url_prefix='/users')


@users.route('', methods=['GET', 'POST'])
def list_users():
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT * FROM users;')
        output = cursor.fetchall()
        return jsonify(output)
    if request.method == 'POST':
        user_data = request.json
        cursor = get_cursor()

        required_fields = ['dni', 'email','gender','name','phone', 'surnames']
        if not all(field in user_data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        cursor = get_cursor()
        cursor.execute('INSERT INTO users (dni, email, gender, name, phone, surnames) VALUES (%s, %s, %s, %s, %s, %s);',
                       (user_data['dni'], user_data['email'], user_data['gender'], user_data['name'], user_data['phone'], user_data['surnames']))

        cursor.connection.commit()
        cursor.close()

        return jsonify({'message': 'User created successfully'}), 201


@users.route('/<string:dni>', methods=['GET', 'PUT', 'DELETE'])
def user_info(dni):
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT * FROM users WHERE dni=%s;', (dni,))
        output = cursor.fetchall()
        return jsonify(output)
    if request.method == 'PUT':
        user_data = request.json
        cursor = get_cursor()

        required_fields = ['email','gender','name','phone', 'surnames']
        if not all(field in user_data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        cursor = get_cursor()
        cursor.execute('UPDATE users SET email=%s, gender=%s, name=%s, phone=%s, surnames=%s WHERE dni=%s',
                       (user_data['email'], user_data['gender'], user_data['name'], user_data['phone'], user_data['surnames'], dni))

        cursor.connection.commit()
        cursor.close()

        return jsonify({'message': 'User modified successfully'}), 201
    if request.method == 'DELETE':
        cursor = get_cursor()
        cursor.execute('DELETE FROM users WHERE dni=%s',
                       (dni,))
        cursor.connection.commit()
        cursor.close()
        return jsonify({'message': 'Delete user successfully'}), 201