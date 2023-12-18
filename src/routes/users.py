from flask import Blueprint, jsonify

from ..db import get_cursor

users = Blueprint('users', __name__, url_prefix='/users')


@users.route('')
def hello():
    cursor = get_cursor()
    cursor.execute('SELECT * FROM prueba')
    output = cursor.fetchall()

    return jsonify(output)
