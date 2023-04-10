import math
import urllib.parse
from typing import Dict, Optional, Tuple, Union
from urllib.parse import SplitResult

from fastapi import Query
from pydantic import BaseModel, validator
from pydantic.dataclasses import dataclass
from starlette.datastructures import URL as StarletteURL

DEFAULT_PAGE_SIZE = 100
DEFAULT_PAGE_NUMBER = 1
MIN_PAGE_NUMBER = 1
MIN_PAGE_SIZE = 1
MAX_PAGE_SIZE = 1000

PAGE_KEY = "page"
PER_PAGE_KEY = "per_page"

TOTAL_COUNT_HEADER = "X-Total-Count"
PAGE_COUNT_HEADER = "X-Page-Count"
LINK_HEADER = "Link"

QueryParamsType = Tuple[Tuple[str, str], ...]


class PaginationParamsConfig:
    allow_population_by_field_name = True


@dataclass(frozen=True, config=PaginationParamsConfig)
class PaginationParams:
    page: int = Query(DEFAULT_PAGE_NUMBER, description="Page number", alias=PAGE_KEY)
    size: int = Query(
        DEFAULT_PAGE_SIZE,
        description="Page size",
        alias=PER_PAGE_KEY,
    )

    @validator("size", pre=True)
    def _page_size_limit(cls, v: int) -> int:
        if v < MIN_PAGE_SIZE:
            return DEFAULT_PAGE_SIZE
        elif v > MAX_PAGE_SIZE:
            return MAX_PAGE_SIZE
        else:
            return v


class PaginationResponseHeaders(BaseModel):
    url: urllib.parse.SplitResult
    page: int
    size: int
    total: int

    class Config:
        frozen = True

    @validator("url", pre=True)
    def _parse_url(cls, v: Union[str, SplitResult]) -> Union[str, SplitResult]:
        if isinstance(v, StarletteURL):  # type: ignore
            v = str(v)  # type: ignore
        if isinstance(v, str):
            return urllib.parse.urlsplit(v)
        return v

    def _parse_qsl(self, query_string: str) -> QueryParamsType:
        params = set()
        paging_params = {x.alias for x in PaginationParams.__pydantic_model__.__fields__.values()}  # type: ignore

        for key, value in urllib.parse.parse_qsl(query_string):
            if key not in paging_params:
                params.add((key, value))

        return tuple(params)

    def _format_links(self) -> str:
        query = self._parse_qsl(self.url.query)

        links = []
        for k, v in self.links.items():
            link_query = [*query, *tuple(v.items())]
            url = self.url._replace(query=urllib.parse.urlencode(link_query))
            formatted = f'<{url.geturl()}>; rel="{k}"'
            links.append(formatted)
        return ", ".join(links)

    @property
    def page_count(self) -> int:
        return max(math.ceil(self.total / self.size), MIN_PAGE_NUMBER)

    @property
    def next_num(self) -> Optional[int]:
        return self.page + 1 if self.page < self.page_count else None

    @property
    def prev_num(self) -> Optional[int]:
        return self.page - 1 if self.page >= MIN_PAGE_NUMBER else None

    @property
    def links(self) -> Dict[str, Dict[str, int]]:
        links = {
            "self": {
                PAGE_KEY: self.page,
                PER_PAGE_KEY: self.size,
            },
            "first": {PAGE_KEY: 1, PER_PAGE_KEY: self.size},
            "last": {PAGE_KEY: self.page_count, PER_PAGE_KEY: self.size},
        }
        if self.next_num:
            links["next"] = {
                PAGE_KEY: self.next_num,
                PER_PAGE_KEY: self.size,
            }
        if self.prev_num:
            links["prev"] = {
                PAGE_KEY: self.prev_num,
                PER_PAGE_KEY: self.size,
            }

        return links

    def headers(self) -> Dict[str, str]:
        return {
            TOTAL_COUNT_HEADER: str(self.total),
            PAGE_COUNT_HEADER: str(self.page_count),
            LINK_HEADER: self._format_links(),
        }
