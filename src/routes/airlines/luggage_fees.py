from flask import Blueprint
from ...db import get_cursor

luggage_fees = Blueprint('luggage_fees', __name__,
                         url_prefix='/<int:airline_id>/luggage_fees')


@luggage_fees.route('')
def hello(airline_id):
    return 'Hello, Clients!'
