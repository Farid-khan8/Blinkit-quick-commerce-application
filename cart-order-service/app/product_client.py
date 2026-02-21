import httpx
import os
from dotenv import load_dotenv

load_dotenv()

print("PRODUCT_SERVICE_URL =", os.getenv("PRODUCT_SERVICE_URL"))

PRODUCT_SERVICE_URL = os.getenv("PRODUCT_SERVICE_URL")

async def get_product(product_id: str):
    async with httpx.AsyncClient() as client:
        response = await client.get(f"{PRODUCT_SERVICE_URL}/products/{product_id}")
        if response.status_code != 200:
            return None
        return response.json()