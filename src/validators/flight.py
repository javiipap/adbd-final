from marshmallow import Schema, fields


class SeatSchema(Schema):
    row = fields.Int(required=True)
    col = fields.Str(required=True)
    luxury_type = fields.Str(required=False)


class FlightSchema(Schema):
    flight_number = fields.Int(required=True)
    origin_id = fields.Int(required=True)
    destination_id = fields.Int(required=True)
    duration = fields.Int(required=True)
    departure_date = fields.Str(required=True)
    arrival_date = fields.Str(required=True)
    seats = fields.List(fields.Nested(SeatSchema), required=True)
    base_price = fields.Decimal(required=True)
    max_cargo_load = fields.Decimal(required=True)
