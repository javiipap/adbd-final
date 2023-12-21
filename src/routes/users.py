from flask import Blueprint, jsonify, request, abort

from ..db import get_cursor
from ..validators import BaseUserSchema, WithDNIUserSchema
from marshmallow import ValidationError

users = Blueprint('users', __name__, url_prefix='/users')


@users.route('', methods=['GET', 'POST'])
def list_users():
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT * FROM users;')
        output = cursor.fetchall()
        return jsonify(output)
    elif request.method == 'POST':
        user_data = request.json

        try:
            WithDNIUserSchema().load(user_data)
        except ValidationError as e:
            abort(400, e.messages)

        cursor = get_cursor()
        cursor.execute('INSERT INTO users (dni, email, gender, name, phone, surnames) VALUES (%s, %s, %s, %s, %s, %s);',
                       (user_data['dni'], user_data['email'], user_data['gender'], user_data['name'], user_data['phone'], user_data['surnames']))

        return jsonify({'message': 'User created successfully'}), 201


@users.route('/<string:dni>', methods=['GET', 'PUT', 'DELETE'])
def user_info(dni):
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute('SELECT * FROM users WHERE dni=%s;', (dni,))
        output = cursor.fetchall()
        return jsonify(output)
    elif request.method == 'PUT':
        user_data = request.json

        try:
            BaseUserSchema().load(user_data)
        except ValidationError as e:
            abort(400, e.messages)

        cursor = get_cursor()
        cursor.execute('UPDATE users SET email=%s, gender=%s, name=%s, phone=%s, surnames=%s WHERE dni=%s',
                       [user_data['email'], user_data['gender'], user_data['name'], user_data['phone'], user_data['surnames'], dni])

        return jsonify({'message': 'User modified successfully'}), 200
    elif request.method == 'DELETE':
        cursor = get_cursor()
        cursor.execute('DELETE FROM users WHERE dni=%s', [dni])

        return jsonify({'message': 'Delete user successfully'}), 200
