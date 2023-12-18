from flask import Blueprint, jsonify

from ...db import get_cursor
from .flights import flights
from .luggage_fees import luggage_fees
from .luxury_fees import luxury_fees

airlines = Blueprint('airlines', __name__, url_prefix='/airlines')
airlines.register_blueprint(flights)
airlines.register_blueprint(luggage_fees)
airlines.register_blueprint(luxury_fees)


@airlines.route('')
def hello():
    ...
