from flask import Blueprint, jsonify

from ..db import get_cursor

bonifications = Blueprint('bonifications', __name__,
                          url_prefix='/bonifications')


@bonifications.route('')
def hello():
    cursor = get_cursor()
    cursor.execute('SELECT * FROM prueba')
    output = cursor.fetchall()

    return jsonify(output)
