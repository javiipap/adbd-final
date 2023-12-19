from marshmallow import Schema, fields


class SeatSchema(Schema):
    row = fields.Int(required=True)
    col = fields.Str(required=True)
    luxury_id = fields.Int(required=True)


class FlightSchema(Schema):
    """
    {
      "flight_number": 50,
      "origin_iata": "",
      "destination_iata": "",
      "duration": 5,
      "departure_date": 134134,
      "arrival_date": 1341324,
      "seats": [{}]
    }"""

    flight_number = fields.Int(required=True)
    origin_iata = fields.Str(required=True)
    destination_iata = fields.Str(required=True)
    duration = fields.Int(required=True)
    departure_date = fields.Int(required=True)
    arrival_date = fields.Int(required=True)
    seats = fields.List(fields.Nested(SeatSchema), required=True)
