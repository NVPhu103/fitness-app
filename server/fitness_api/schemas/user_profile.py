from typing import Optional
from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID
import enum
from .user import UserModel


class UserProfileStatus(enum.Enum):
    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"


class UserProfileActivityLevel(enum.Enum):
    NOT_VERY_ACTIVE = "NOT VERY ACTIVE"
    LIGHTLY_ACTIVE = "LIGHTLY ACTIVE"
    ACTIVE = "ACTIVE"
    VERY_ACTIVE = "VERY ACTIVE"


class BaseUserProfileModel(BaseModelWithConfig):
    user_id: UUID = Field(..., title="User ID", alias="userId")
    current_weight: float = Field(
        ..., title="The current weight of the User", alias="currentWeight"
    )
    height: float = Field(..., title="The height of the user")
    desired_weight: float = Field(
        ..., title="The weight that the user wants to achieve", alias="desiredWeight"
    )
    year_of_birth: int = Field(
        ..., title="the year of birth of the user", alias="yearOfBirth"
    )
    activity_level: UserProfileActivityLevel = Field(
        ..., title="the exercise frequency", alias="activityLevel"
    )


class PostUserProfileModel(BaseUserProfileModel):
    class Config(BaseUserProfileModel.Config):
        schema_extra = {
            "example": {
                "user_id": "52cedffd-1e53-4693-9fcb-443d003211fd",
                "current_weight": "80.5",
                "height": "172",
                "desired_weight": "72",
                "year_of_birth": 2001,
                "activity_level": UserProfileActivityLevel.ACTIVE.value,
            }
        }


class PatchUserProfileModel(BaseModelWithConfig):
    current_weight: Optional[float] = Field(
        None, title="The current weight of the User", alias="currentWeight"
    )
    height: Optional[float] = Field(None, title="The height of the user")
    desired_weight: Optional[float] = Field(
        None, title="The weight that the user wants to achieve", alias="desiredWeight"
    )
    year_of_birth: Optional[int] = Field(
        None, title="the year of birth of the user", alias="yearOfBirth"
    )
    activity_level: Optional[UserProfileActivityLevel] = Field(
        None, title="the exercise frequency", alias="activityLevel"
    )

    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {
                "current_weight": "78",
                "desired_weight": "73",
                "height": "174",
                "year_of_birth": 1999,
                "activity_level": UserProfileActivityLevel.ACTIVE.value,
            }
        }


class PatchStatusUserProfileModel(BaseModelWithConfig):
    status: UserProfileStatus = Field(UserProfileStatus.ACTIVE.value)


class UserProfileModel(BaseUserProfileModel):
    id: UUID = Field(..., title="User Profile ID")
    user: Optional[UserModel] = Field(
        None, title="The User to which this profile belongs"
    )
    status: UserProfileStatus = Field(..., title="Staus of the user")
    maximum_calorie_intake: int = Field(
        ..., alias="maximumCalorieIntake", title="Maximum calorie intake per day"
    )
