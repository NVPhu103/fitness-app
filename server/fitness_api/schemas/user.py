import enum
from .config import BaseModelWithConfig
from pydantic import Field, validator
from fitness_api.helpers import email_re
from uuid import UUID


class UserRole(enum.Enum):
    USER = "USER"
    ADMIN = "ADMIN"


class BaseUserModel(BaseModelWithConfig):
    email: str = Field(..., title="Email")

    @validator("email")
    def validate_email(cls, value: str) -> str:
        if not email_re.match(value):
            raise ValueError("Value is not a valid email")
        return value


class PostUserModel(BaseUserModel):
    hashed_password: str = Field(..., title="Hashed Password", alias="password")
    confirm_hashed_password: str = Field(
        ..., title="Confirmed Hashed Password", alias="confirmPassword"
    )

    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {
                "email": "nguyenvanphu103@gmail.com",
                "password": "password",
                "confirmPassword": "password",
            }
        }


class UserModel(BaseUserModel):
    id: UUID = Field(..., title="User ID")
    role: UserRole = Field(..., title="User role")

    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {
                "id": "aae992db-bb4c-43da-8118-5f9696a8b684",
                "email": "nguyenvanphu103@gmail.com",
                "role": UserRole.USER.value,
            }
        }


class LoginUserModel(BaseModelWithConfig):
    email: str = Field(..., title="Email")
    password: str = Field(..., title="Password")

    @validator("email")
    def validate_email(cls, value: str) -> str:
        if not email_re.match(value):
            raise ValueError("Value is not a valid email")
        return value

    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {"email": "nguyenvanphu103@gmail.com", "password": "password"}
        }
