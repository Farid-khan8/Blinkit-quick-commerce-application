from fastapi import APIRouter, HTTPException, Depends
from app.database import users_collection
from app.schemas import UserCreate, UserLogin
from app.auth import hash_password, verify_password, create_token, verify_token
from fastapi import Header
from datetime import datetime
from bson import ObjectId

router = APIRouter()

def get_current_user(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Missing token")

    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Invalid token format")

    token = authorization.split(" ")[1]

    payload = verify_token(token)

    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")

    return payload

HARDCODED_OTP = "1234"

@router.post("/register")
async def register(user: UserCreate):
    if user.otp != HARDCODED_OTP:
        raise HTTPException(status_code=400, detail="Invalid OTP")

    existing = await users_collection.find_one({"email": user.email})
    if existing:
        raise HTTPException(status_code=400, detail="Email already exists")

    new_user = {
        "name": user.name,
        "email": user.email,
        "password": hash_password(user.password),
        "created_at": datetime.utcnow()
    }

    result = await users_collection.insert_one(new_user)

    return {"message": "User created successfully"}

@router.post("/login")
async def login(user: UserLogin):
    db_user = await users_collection.find_one({"email": user.email})

    if not db_user or not verify_password(user.password, db_user["password"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_token({"user_id": str(db_user["_id"])})

    return {
        "access_token": token,
        "token_type": "bearer"
    }


@router.get("/profile")
async def get_profile(user=Depends(get_current_user)):
    user_id = user.get("user_id")

    db_user = await users_collection.find_one({"_id": ObjectId(user_id)})

    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")

    return {
        "id": str(db_user["_id"]),
        "name": db_user["name"],
        "email": db_user["email"],
        "created_at": db_user["created_at"]
    }