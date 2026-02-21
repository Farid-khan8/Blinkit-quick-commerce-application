from fastapi import FastAPI
from app.routes import router
from app.seed import seed_data
import asyncio

app = FastAPI(title="Product Catalog Service")

app.include_router(router)

@app.on_event("startup")
async def startup_event():
    await seed_data()

@app.get("/health")
async def health():
    return {"status": "Product service running"}