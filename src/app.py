import json
from flask import Flask, Blueprint
from werkzeug.exceptions import HTTPException

from .routes import users, airports, bonifications, airlines, bookings
from .db import close_db

app = Flask(__name__)

API_BASE = '/api'

prefixed = Blueprint('prefixed', __name__, url_prefix=API_BASE)

prefixed.register_blueprint(users)
prefixed.register_blueprint(airports)
prefixed.register_blueprint(bonifications)
prefixed.register_blueprint(airlines)
prefixed.register_blueprint(bookings)

app.register_blueprint(prefixed)

app.teardown_appcontext(close_db)


@app.errorhandler(HTTPException)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    # start with the correct headers and status code from the error
    response = e.get_response()
    # replace the body with JSON
    response.data = json.dumps({
        "code": e.code,
        "name": e.name,
        "message": e.description,
    })
    response.content_type = "application/json"
    return response
