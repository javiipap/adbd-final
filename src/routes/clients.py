from flask import Blueprint, jsonify

from ..db import get_cursor

clients = Blueprint('clients', __name__)


@clients.route('')
def hello():
    cursor = get_cursor()
    cursor.execute('SELECT * FROM prueba')
    output = cursor.fetchall()

    return jsonify(output)
