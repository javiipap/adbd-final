import json
from flask import Flask
from werkzeug.exceptions import HTTPException

from .routes import clients, flights, hotels
from .db import close_db

app = Flask(__name__)

API_BASE = '/api'

app.register_blueprint(clients, url_prefix=f'{API_BASE}/clients')
app.register_blueprint(flights, url_prefix=f'{API_BASE}/flights')
app.register_blueprint(hotels, url_prefix=f'{API_BASE}/hotels')

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
