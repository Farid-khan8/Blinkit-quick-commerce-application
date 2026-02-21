from fastapi import FastAPI
from app.routes import router

app = FastAPI(title="Delivery Service")

app.include_router(router)

@app.get("/health")
async def health():
    return {"status": "Delivery service running"}