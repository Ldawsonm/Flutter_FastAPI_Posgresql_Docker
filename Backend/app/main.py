from typing import Dict
from fastapi import FastAPI, Depends, HTTPException
from pydantic import ValidationError
from app.models.schemas import Nutrients, FoodItem, SearchResponse
from app.database_services.database import Base
from app.database_services.database import engine
from app.database_services.database import SessionLocal
from app.database_services.services import get_todos, get_todo_by_id, create_todo, update_todo, delete_todo
from fastapi.middleware.cors import CORSMiddleware
from app import helpers
import httpx
from app.config import settings


Base.metadata.create_all(
    bind=engine
)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/search", response_model=SearchResponse)
async def search_foods(query: str, page: int, page_size: int):
    size = page_size or min(settings.default_page_size, settings.MAX_PAGE_SIZE)
    params = {
        "api_key": settings.usda,
        "query": query,
        "pageNumber": page,
        "pageSize": size,
        # We can request a few key nutrients in search results for convenience
        "requireAllWords": False,
    }

    async with await helpers._get_client() as client:
        try:
            r = await client.get(settings.USDA_SEARCH_URL, params=params)
        except httpx.HTTPError as e:
            raise HTTPException(status_code=502, detail=f"USDA search failed: {e}")
        if r.status_code == 401:
            raise HTTPException(status_code=502, detail="Invalid USDA API key")
        if r.status_code >= 400:
            raise HTTPException(status_code=502, detail=f"USDA search error: {r.text}")
    data = r.json()
    foods = data.get("foods", [])

    # Normalize nutrients shape for search results if available
    for f in foods:
        # Some search payloads place nutrient lists as 'foodNutrients'
        f.setdefault("foodNutrients", f.get("foodNutrients", []))
    
    items = [helpers._simplify_food(f) for f in foods]
    total_hits = int(data.get("totalHits", 0))
    total_pages = int((total_hits + size - 1) // size) if size else 0

    return SearchResponse(items=items, page=page, page_size=size, total_hits=total_hits, total_pages=total_pages)



@app.get("/foods/{fdc_id}", response_model=FoodItem)
async def food_details(fdc_id: int):
    # cached = _cache_get(fdc_id)
    # if cached:
    #     try:
    #         return FoodItem.model_validate(cached)
    #     except ValidationError:
    #         pass
    params = {"api_key": settings.usda_api_key}
    url = settings.USDA_DETAILS_URL.format(fdc_id=fdc_id)
    async with await helpers._get_client() as client:
        try:
            r = await client.get(url, params=params)
        except httpx.HTTPError as e:
            raise HTTPException(status_code=502, detail=f"USDA details failed:{e}")
    if r.status_code == 404:
        raise HTTPException(status_code=404, detail="Food not found")
    if r.status_code >= 400:
        raise HTTPException(status_code=502, detail=f"USDA details error: {r.text}")
    food_raw = r.json()
    item = helpers._simplify_food(food_raw)
    # cache
    # _cache_set(fdc_id, item.model_dump())
    return item

@app.get("/health")
async def health() -> Dict[str, str]:
    return {"status": "ok"}



# @app.get("/todos/{skip}/{limit}")
# async def get_todos_list(skip: int = 0, limit: int = 100, session=Depends(get_db)):
#     todos = get_todos(skip=skip, limit=limit, db=session)
#     return todos


# @app.get("/todo/{todo_id}")
# async def get_todo(todo_id: int, session=Depends(get_db)):
#     todo = get_todo_by_id(todo_id=todo_id, db=session)
#     if todo:
#         return todo
#     return {"message": "Todo not found"}


# @app.delete("/todo/{todo_id}")
# async def delete_todo_by_id(todo_id: int, session=Depends(get_db)):
#     todo = delete_todo(todo_id=todo_id, db=session)
#     if todo:
#         return {"message": f"Deleted todo with id {todo_id}"}
#     return {"message": "Todo not found"}


# @app.post("/todo")
# async def create(request: TodoCreate, session=Depends(get_db)):
#     todo = create_todo(todo=request, db=session)
#     return todo


# @app.put("/todo/{todo_id}")
# async def update_todo_by_id(request: TodoCreate, todo_id: int, session=Depends(get_db)):
#     todo = update_todo(todo_id=todo_id, todo=request, db=session)
#     if todo:
#         return todo
#     return {"message": "Todo not found"}
