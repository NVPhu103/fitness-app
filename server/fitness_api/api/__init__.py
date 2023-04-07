from . import user, food
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