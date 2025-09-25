import os
import httpx
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    db_user: str
    db_pass: str
    db_name: str
    db_host: str
    fda_api_key: str
    default_page_size: int = 20
    details_cache_ttl: int = 600

    USDA_SEARCH_URL = "https://api.nal.usda.gov/fdc/v1/foods/search"
    USDA_DETAILS_URL = "https://api.nal.usda.gov/fdc/v1/food/{fdc_id}"
    MAX_PAGE_SIZE = 20
    TIMEOUT = httpx.Timeout(15.0, connect=10.0)

    NUTRIENT_CODES = {
    "calories": "208",
    "protein": "203",
    "carbs": "205",
    "fat": "204",
    "fiber": "291",
    }



    class Config:
        ROOT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
        env_file = f"{ROOT_DIR}/.env"


settings = Settings()
