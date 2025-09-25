from typing import Optional, List
from pydantic import BaseModel


class Todo(BaseModel):
    id: int
    name: str
    description: str
    priority: int


class TodoCreate(BaseModel):
    name: str
    description: str
    priority: int

class Nutrients(BaseModel):
    calories: Optional[float] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None
    fiber: Optional[float] = None
    unit: str = "g"

class FoodItem(BaseModel):
    fdcId: int
    description: str
    brandOwner: Optional[str] = None
    dataType: Optional[str] = None
    nutrients: Optional[Nutrients] = None

class SearchResponse(BaseModel):
    items: List[FoodItem]
    page: int
    page_size: int
    total_hits: int
    total_pages: int