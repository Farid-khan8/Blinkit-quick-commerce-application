# from pydantic import BaseModel
# from datetime import datetime

# class UpdateStatus(BaseModel):
#     status: str

from pydantic import BaseModel
from enum import Enum


class OrderStatus(str, Enum):
    PLACED = "PLACED"
    PACKED = "PACKED"
    OUT_FOR_DELIVERY = "OUT_FOR_DELIVERY"
    DELIVERED = "DELIVERED"


class UpdateStatus(BaseModel):
    status: OrderStatus