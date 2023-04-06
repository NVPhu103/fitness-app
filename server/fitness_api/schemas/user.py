from .config import BaseModelWithConfig
from pydantic import StrictStr, Field, validator
from fitness_api.helpers import email_re
from uuid import UUID


class PostUserModel(BaseModelWithConfig):
    username: StrictStr = Field(None, title="Username")
    hashed_password: str = Field(None, title= "Hashed Password", alias="password")
    confirm_hashed_password: str = Field(None, title= "Confirmed Hashed Password", alias="confirmPassword")
    email: str = Field(..., title="Email")

    @validator("email")
    def validate_email(cls, value: str) -> str:
        if not email_re.match(value):
            raise ValueError("Value is not a valid email")
        return value
    
    class Config(BaseModelWithConfig.Config):
        schema_extra={
            "example": {
                "username": "vanphu",
                "password": "password",
                "confirmPassword": "password",
                "email": "nguyenvanphu103@gmail.com"
            }
        }
    

class UserModel(PostUserModel):
    id: UUID = Field(..., title="ID")
