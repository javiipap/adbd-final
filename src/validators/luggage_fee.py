from marshmallow import Schema, fields, validate


class LuggageFeeSchema(Schema):
    fee = fields.Decimal(required=True)
    weight = fields.Int(required=True)
