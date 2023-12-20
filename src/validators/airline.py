from marshmallow import Schema, fields, validate


class AirlineSchema(Schema):
    icao = fields.Str(required=True)
    id = fields.Int(required=True)
    name = fields.Str(required=True)
