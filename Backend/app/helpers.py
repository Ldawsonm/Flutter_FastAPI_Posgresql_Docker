from __future__ import annotations
from typing import Any, Dict
from app.models.schemas import FoodItem, Nutrients
import httpx
from app.config import settings

async def _get_client() -> httpx.AsyncClient:
    return httpx.AsyncClient(timeout=settings.TIMEOUT)

def _simplify_food(food: Dict[str, Any]) -> FoodItem:
    return FoodItem(
        fdcId=int(food["fdcId"]),
        description=food.get("description") or food.get("descriptionLegacy") or "",
        brandOwner=food.get("brandOwner"),
        dataType=food.get("dataType"),
        nutrients=_extract_key_nutrients(food),
    )

def _extract_key_nutrients(food: Dict[str, Any]) -> Nutrients:
    # Food details response contains either 'foodNutrients' or within search 'foodNutrients' short list
    nutrients = {n.get("nutrient", {}).get("number") or n.get("nutrientNumber"): 
                    n for n in food.get("foodNutrients", [])}
    def val(code: str) -> Optional[float]:
        entry = nutrients.get(code)
        if not entry:
            return None
        # Search response might shape as {nutrientNumber, value}, details as {amount}
        if "amount" in entry:
            v = entry.get("amount")
        else:
            v = entry.get("value")
        try:
            return float(v) if v is not None else None
        except (TypeError, ValueError):
            return None
    return Nutrients(
        calories=val(settings.NUTRIENT_CODES["calories"]),
        protein=val(settings.NUTRIENT_CODES["protein"]),
        carbs=val(settings.NUTRIENT_CODES["carbs"]),
        fat=val(settings.NUTRIENT_CODES["fat"]),
        fiber=val(settings.NUTRIENT_CODES["fiber"]),
    )
