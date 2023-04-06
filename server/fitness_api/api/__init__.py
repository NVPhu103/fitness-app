from . import user
from fastapi import FastAPI

def configure_routes(app: FastAPI) -> None:
    app.include_router(
        user.router,
        tags=user.TAGS,
        prefix=f"/{user.PREFIX}",
    )