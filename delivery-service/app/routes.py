from fastapi import APIRouter, HTTPException
from app.database import delivery_collection
from app.schemas import UpdateStatus
from datetime import datetime
from bson import ObjectId

router = APIRouter()

VALID_STATUSES = [
    "PLACED",
    "PACKED",
    "OUT_FOR_DELIVERY",
    "DELIVERED"
]

STATUS_FLOW = {
    "PLACED": "PACKED",
    "PACKED": "OUT_FOR_DELIVERY",
    "OUT_FOR_DELIVERY": "DELIVERED"
}

@router.get("/order/{order_id}/status")
async def get_status(order_id: str):
    record = await delivery_collection.find_one({"order_id": order_id})
    
    if not record:
        raise HTTPException(status_code=404, detail="Order not found")

    record["_id"] = str(record["_id"])
    return record


# @router.post("/order/{order_id}/update-status")
# async def update_status(order_id: str, update: UpdateStatus):
    
#     if update.status not in VALID_STATUSES:
#         raise HTTPException(status_code=400, detail="Invalid status")

#     existing = await delivery_collection.find_one({"order_id": order_id})

#     if not existing:
#         # create new status entry
#         new_record = {
#             "order_id": order_id,
#             "status": update.status,
#             "last_updated": datetime.utcnow()
#         }
#         await delivery_collection.insert_one(new_record)
#     else:
#         await delivery_collection.update_one(
#             {"order_id": order_id},
#             {
#                 "$set": {
#                     "status": update.status,
#                     "last_updated": datetime.utcnow()
#                 }
#             }
#         )

#     return {"message": "Status updated"}

@router.post("/order/{order_id}/update-status")
async def update_status(order_id: str, update: UpdateStatus):

    if update.status not in VALID_STATUSES:
        raise HTTPException(status_code=400, detail="Invalid status")

    existing = await delivery_collection.find_one({"order_id": order_id})

    # First status must be PLACED
    if not existing:
        if update.status != "PLACED":
            raise HTTPException(
                status_code=400,
                detail="Order must start with PLACED"
            )

        await delivery_collection.insert_one({
            "order_id": order_id,
            "status": "PLACED",
            "last_updated": datetime.utcnow()
        })

        return {"message": "Order status created"}

    current_status = existing["status"]

    if STATUS_FLOW.get(current_status) != update.status:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid transition from {current_status} to {update.status}"
        )

    await delivery_collection.update_one(
        {"order_id": order_id},
        {
            "$set": {
                "status": update.status,
                "last_updated": datetime.utcnow()
            }
        }
    )

    return {"message": "Status updated"}