from fastapi import APIRouter, HTTPException
from app.database import products_collection
from bson import ObjectId

router = APIRouter()

@router.get("/products")
async def get_products():
    products = []
    async for product in products_collection.find():
        product["_id"] = str(product["_id"])
        products.append(product)
    return products


@router.get("/products/{product_id}")
async def get_product(product_id: str):
    product = await products_collection.find_one({"_id": ObjectId(product_id)})
    
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    product["_id"] = str(product["_id"])
    return product


@router.get("/categories")
async def get_categories():
    categories = await products_collection.distinct("category")
    return categories