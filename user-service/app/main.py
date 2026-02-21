from fastapi import FastAPI
from app.routes import router

app = FastAPI(title="User Service")

app.include_router(router)

@app.get("/health")
async def health():
    return {"status": "User service running"}