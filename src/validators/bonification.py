from marshmallow import Schema, fields, validate


class BonificationSchema(Schema):
    name = fields.Str(required=True)
    value = fields.Int(required=True)
    description = fields.Str(required=True)
    type = fields.Str(required=True, validate=validate.OneOf(
        ["percentage", "fixed"]))
