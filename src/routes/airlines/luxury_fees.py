from flask import Blueprint, request, jsonify

luxury_fees = Blueprint('luxury_fees', __name__,
                        url_prefix='/<int:airline_id>/luxury_fees')


@luxury_fees.route('')
# GET /airlines/<airline_id>/luxury_fees
def hello(airline_id):
    return 'Hello, Clients!'
