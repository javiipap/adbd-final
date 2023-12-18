from flask import Blueprint

flights = Blueprint('flights', __name__,
                    url_prefix='/<int:airline_id>/flights')


@flights.route('')
def hello(airline_id):
    return 'Hello, Clients!'
