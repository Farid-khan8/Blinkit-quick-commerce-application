from fastapi import APIRouter, HTTPException
from app.database import cart_collection, orders_collection
from app.schemas import CartItem, OrderCreate
from app.product_client import get_product
from app.delivery_client import create_delivery
from datetime import datetime
from bson import ObjectId

import httpx
import os

DELIVERY_SERVICE_URL = os.getenv(
    "DELIVERY_SERVICE_URL",
    "http://delivery-service:8000"
)

router = APIRouter()

# //add_to_cart endpoints
@router.post("/cart/add")
async def add_to_cart(item: CartItem):
    product = await get_product(item.product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    existing_item = await cart_collection.find_one({
        "user_id": item.user_id,
        "product_id": item.product_id
    })

    if existing_item:
        await cart_collection.update_one(
            {"_id": existing_item["_id"]},
            {"$inc": {"quantity": item.quantity}}
        )
        return {"message": "Quantity updated"}
    else:
        cart_item = {
            "user_id": item.user_id,
            "product_id": item.product_id,
            "quantity": item.quantity
        }

        await cart_collection.insert_one(cart_item)
        return {"message": "Item added to cart"}

# //get_cart endpoints
@router.get("/cart/{user_id}")
async def get_cart(user_id: str):
    items = []

    async for item in cart_collection.find({"user_id": user_id}):
        product = await get_product(item["product_id"])

        if product:
            items.append({
                "_id": str(item["_id"]),
                "product_id": item["product_id"],
                "quantity": item["quantity"],
                "name": product["name"],
                "price": product["price"]
            })

    return items

# //create_order endpoints
@router.post("/order/create")
async def create_order(order: OrderCreate):
    cart_items = cart_collection.find({"user_id": order.user_id})

    total = 0
    items = []

    async for item in cart_items:
        product = await get_product(item["product_id"])
        if not product:
            continue

        item_total = product["price"] * item["quantity"]
        total += item_total

        items.append({
            "product_id": item["product_id"],
            "quantity": item["quantity"],
            "price": product["price"]
        })

    new_order = {
        "user_id": order.user_id,
        "items": items,
        "total": total,
        "created_at": datetime.utcnow()
    }

    result = await orders_collection.insert_one(new_order)

    order_id = str(result.inserted_id)
    # notify delivery service
    await create_delivery(order_id)

    # clear cart
    await cart_collection.delete_many({"user_id": order.user_id})

    # notify delivery service
    # async with httpx.AsyncClient() as client:
    #     await client.post(
    #         f"{DELIVERY_SERVICE_URL}/order/{str(result.inserted_id)}/update-status",
    #         json={"status": "PLACED"}
    #     )

    return {
        "message": "Order created",
        "order_id": str(result.inserted_id),
        "total": total
    }

# //get_orders endpoints
@router.get("/orders/{user_id}")
async def get_orders(user_id: str):
    orders = []
    async for order in orders_collection.find({"user_id": user_id}):
        order["_id"] = str(order["_id"])
        orders.append(order)
    return orders

# //remove_from_cart endpoints
@router.delete("/cart/remove/{cart_id}")
async def remove_from_cart(cart_id: str):
    result = await cart_collection.delete_one({"_id": ObjectId(cart_id)})

    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Item not found")

    return {"message": "Item removed"}

# //increase_quantity endpoints
@router.put("/cart/increase/{cart_id}")
async def increase_quantity(cart_id: str):
    result = await cart_collection.update_one(
        {"_id": ObjectId(cart_id)},
        {"$inc": {"quantity": 1}}
    )

    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="Item not found")

    return {"message": "Quantity increased"}

# //decrease_quantity endpoints
@router.put("/cart/decrease/{cart_id}")
async def decrease_quantity(cart_id: str):
    item = await cart_collection.find_one({"_id": ObjectId(cart_id)})

    if not item:
        raise HTTPException(status_code=404, detail="Item not found")

    if item["quantity"] <= 1:
        await cart_collection.delete_one({"_id": ObjectId(cart_id)})
        return {"message": "Item removed"}

    await cart_collection.update_one(
        {"_id": ObjectId(cart_id)},
        {"$inc": {"quantity": -1}}
    )

    return {"message": "Quantity decreased"}
