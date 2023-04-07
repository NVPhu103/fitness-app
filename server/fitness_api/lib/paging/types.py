from dataclasses import dataclass, field
from typing import Generic, List, TypeVar

from .utils import _calculate_offset

T = TypeVar("T")


@dataclass
class PagedResultSet(Generic[T]):
    """Results wrapper for SqlA >= 1.4

    Wraps results for consumption by pagination aware callers.
    """

    page: int
    size: int
    total: int
    offset: int = field(init=False)
    records: List[T]

    def __post_init__(self) -> None:
        self.offset = _calculate_offset(self.page, self.size)

    def __len__(self) -> int:
        return len(self.records)
