from flask import Blueprint

hotels = Blueprint('hotels', __name__)


@hotels.route('')
def hello():
    return 'Hello, hotels!'
