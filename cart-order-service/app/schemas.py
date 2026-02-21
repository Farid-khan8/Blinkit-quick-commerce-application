from pydantic import BaseModel
from typing import List

class CartItem(BaseModel):
    user_id: str
    product_id: str
    quantity: int

class OrderCreate(BaseModel):
    user_id: str