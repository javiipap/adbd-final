from marshmallow import Schema, fields


class BaseUserSchema(Schema):
    email = fields.Str(required=True)
    gender = fields.Str(required=True)
    name = fields.Str(required=True)
    phone = fields.Str(required=True)
    surnames = fields.Str(required=True)


class WithDNIUserSchema(BaseUserSchema):
    dni = fields.Str(required=True)
