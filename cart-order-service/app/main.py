from fastapi import FastAPI
from app.routes import router

app = FastAPI(title="Cart & Order Service")

app.include_router(router)

@app.get("/health")
async def health():
    return {"status": "Cart service running"}