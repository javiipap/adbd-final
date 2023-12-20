from flask import Blueprint, jsonify, request, abort
from marshmallow import ValidationError

from ..db import get_cursor
from ..validators import BonificationSchema

bonifications = Blueprint('bonifications', __name__,
                          url_prefix='/bonifications')


@bonifications.route('', methods=['GET', 'POST'])
def list_bonification():
    if request.method == 'GET':
        cursor = get_cursor()
        cursor.execute(
            'SELECT name, value, description, type FROM bonifications;')
        output = cursor.fetchall()
        return jsonify(output)

    bonification_data = request.json
    cursor = get_cursor()

    try:
        BonificationSchema().load(bonification_data)
    except ValidationError as e:
        abort(400, e.messages)

    cursor = get_cursor()
    cursor.execute('INSERT INTO bonifications (name, value, description, type) VALUES (%s, %s, %s, %s);',
                   (bonification_data['name'], bonification_data['value'], bonification_data['description'], bonification_data['type']))

    return jsonify({'message': 'Bonification created successfully'}), 201
