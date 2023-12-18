from flask import Blueprint

reservations = Blueprint('reservations', __name__, url_prefix='/reservations')


@reservations.route('')
def hello():
    return 'Hello, Resrvations!'
