import httpx
import os

DELIVERY_SERVICE_URL = os.getenv("DELIVERY_SERVICE_URL")

async def create_delivery(order_id: str):
    async with httpx.AsyncClient() as client:
        await client.post(
            f"{DELIVERY_SERVICE_URL}/order/{order_id}/update-status",
            json={"status": "PLACED"}
        )