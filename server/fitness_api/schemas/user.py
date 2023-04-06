from .config import BaseModelWithConfig
from pydantic import StrictStr, Field, validator
from fitness_api.helpers import email_re, username_re
from uuid import UUID



class BaseUserModel(BaseModelWithConfig):
    username: StrictStr = Field(None, title="Username")
    email: str = Field(..., title="Email")

    @validator("email")
    def validate_email(cls, value: str) -> str:
        if not email_re.match(value):
            raise ValueError("Value is not a valid email")
        return value

    @validator("username")
    def validate_username(cls, value: StrictStr) -> StrictStr:
        if not username_re.match(value):
            raise ValueError("Username is invalid")
        return value
    
class PostUserModel(BaseUserModel):
    hashed_password: str = Field(None, title= "Hashed Password", alias="password")
    confirm_hashed_password: str = Field(None, title= "Confirmed Hashed Password", alias="confirmPassword")
    class Config(BaseModelWithConfig.Config):
        schema_extra= {
            "example": {
                "username": "vanphu2",
                "password": "password",
                "confirmPassword": "password",
                "email": "nguyenvanphu103@gmail.com"
            }
        }


class UserModel(BaseUserModel):
    id: UUID = Field(..., title="ID")
    class Config(BaseModelWithConfig.Config):
        schema_extra= {
            "example": {
                "id": "aae992db-bb4c-43da-8118-5f9696a8b684",
                "username": "vanphu2",
                "email": "nguyenvanphu103@gmail.com"
            }
        }


class LoginUserModel(BaseModelWithConfig):
    username: StrictStr = Field(None, title="Username")
    password: str = Field(None, title= "Password")

    @validator("username")
    def validate_username(cls, value: StrictStr) -> StrictStr:
        if not username_re.match(value):
            raise ValueError("Username is invalid")
        return value
    class Config(BaseModelWithConfig.Config):
        schema_extra= {
            "example": {
                "username": "vanphu1",
                "password": "password"
            }
        }