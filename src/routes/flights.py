from flask import Blueprint

flights = Blueprint('flights', __name__)


@flights.route('')
def hello():
    return 'Hello, Clients!'
