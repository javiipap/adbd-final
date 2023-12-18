from flask import Blueprint

airports = Blueprint('airports', __name__, url_prefix='/airports')


@airports.route('')
def hello():
    return 'Hello, airports!'
