from marshmallow import Schema, fields


class BaggageSchema(Schema):
    weight = fields.Float(required=True)


class SeatSchema(Schema):
    row = fields.Int(required=True)
    col = fields.Str(required=True)
    luggage = fields.List(fields.Nested(BaggageSchema), required=False)
    user_info = fields.Dict(required=False)


class FlightSchema(Schema):
    flight_id = fields.Str(required=True)
    seats = fields.List(fields.Nested(SeatSchema), required=True)


class BookingSchema(Schema):
    user_id = fields.Str(required=True)
    flights = fields.List(fields.Nested(FlightSchema), required=True)
