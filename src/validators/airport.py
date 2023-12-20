from marshmallow import Schema, fields, validate


class AirportSchema(Schema):
    name = fields.Str(required=True)
    country = fields.Str(required=True)
    city = fields.Str(required=True)
    iata = fields.Str(required=True)
