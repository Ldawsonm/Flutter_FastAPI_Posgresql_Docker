import time
from typing import Any, Dict, Optional
from app.config import settings


_details_cache: Dict[int, Dict[str, Any]] = {}

def _cache_get(fdc_id: int) -> Optional[Dict[str, Any]]:
    entry = _details_cache.get(fdc_id)
    if not entry:
        return None
    if time.time() - entry["ts"] > settings.details_cache_ttl:
        _details_cache.pop(fdc_id, None)
        return None
    return entry["data"]

def _cache_set(fdc_id: int, data: Dict[str, Any]) -> None:
    _details_cache[fdc_id] = {"ts": time.time(), "data": data}