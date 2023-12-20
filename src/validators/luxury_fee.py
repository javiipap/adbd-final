from marshmallow import Schema, fields, validate


class LuxuryFeeSchema(Schema):
    description = fields.Str(required=True)
    fee = fields.Decimal(required=True)
    luxury_type = fields.Str(required=True)
