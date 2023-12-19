from marshmallow import Schema, fields


class BaggageSchema(Schema):
    weight = fields.Float(required=True)


class SeatSchema(Schema):
    row = fields.Int(required=True)
    col = fields.Str(required=True)


class FlightSchema(Schema):
    flight_id = fields.Str(required=True)
    seats = fields.List(fields.Nested(SeatSchema), required=True)
    luggage = fields.List(fields.Nested(BaggageSchema), required=False)


class BookingSchema(Schema):
    """
    {
      user_id: string,
      flights: {
        flight_id: string,
        seats: { line: number, column: string }[],
        luggage: { weight: number }[]
      }[]
    }"""

    user_id = fields.Str(required=True)
    flights = fields.List(fields.Nested(FlightSchema), required=True)
