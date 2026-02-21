from app.database import products_collection
import asyncio

sample_products = [
    {
        "name": "Milk 1L",
        "description": "Fresh dairy milk",
        "price": 60,
        "category": "Dairy",
        "image_url": "https://via.placeholder.com/150",
        "available": True
    },
    {
        "name": "Bread",
        "description": "Whole wheat bread",
        "price": 40,
        "category": "Bakery",
        "image_url": "https://via.placeholder.com/150",
        "available": True
    },
    {
        "name": "Apple 1kg",
        "description": "Fresh apples",
        "price": 120,
        "category": "Fruits",
        "image_url": "https://via.placeholder.com/150",
        "available": True
    }
]

async def seed_data():
    count = await products_collection.count_documents({})
    if count == 0:
        await products_collection.insert_many(sample_products)
        print("Products seeded successfully!")
    else:
        print("Products already exist.")

if __name__ == "__main__":
    asyncio.run(seed_data())