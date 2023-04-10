from fastapi import FastAPI
from .api import configure_routes
from .config import APPLICATION_TITLE
from .middlewares import configure_middlewares
app = FastAPI(
    title=APPLICATION_TITLE,
)

configure_middlewares(app=app)
configure_routes(app=app)
