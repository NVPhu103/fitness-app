from . import user, food, user_profile, exercise, diary, food_diary, food_history
from fastapi import FastAPI


def configure_routes(app: FastAPI) -> None:
    app.include_router(
        user.router,
        tags=user.TAGS,
        prefix=f"/{user.PREFIX}",
    )
    app.include_router(
        food.router,
        tags=food.TAGS,
        prefix=f"/{food.PREFIX}",
    )
    app.include_router(
        user_profile.router,
        tags=user_profile.TAGS,
        prefix=f"/{user_profile.PREFIX}",
    )
    app.include_router(
        exercise.router,
        tags=exercise.TAGS,
        prefix=f"/{exercise.PREFIX}",
    )
    app.include_router(
        diary.router,
        tags=diary.TAGS,
        prefix=f"/{diary.PREFIX}",
    )
    app.include_router(
        food_diary.router,
        tags=food_diary.TAGS,
        prefix=f"/{food_diary.PREFIX}",
    )
    app.include_router(
        food_history.router,
        tags=food_history.TAGS,
        prefix=f"/{food_history.PREFIX}",
    )
