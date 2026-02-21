# 🛒 B2C Quick Commerce Application (Blinkit-Like)

This project is a minimal B2C Quick Commerce Application inspired by Blinkit, developed as part of an intern assignment to demonstrate understanding of:

- Microservices architecture
- Backend API development using FastAPI
- Flutter mobile application integration
- Docker containerization
- Kubernetes orchestration
- End-to-end service communication

## 📌 Overview

The application allows users to browse products, add items to cart, place orders, and track delivery status.

- Register & Login (JWT Authentication)
- Browse products
- View product details
- Add items to cart
- Place orders
- Track delivery status

## 🏗️ Architecture

The system follows a Microservices Architecture consisting of four independent backend services and one Flutter frontend.

```bash
    Flutter App
    │
    ▼
    User Service ── Authentication (JWT)
    Product Service ── Product Catalog
    Cart & Order Service ── Cart + Order Management
    Delivery Service ── Order Tracking
    │
    ▼
    MongoDB (separate collections per service)
```

Each microservice:

- Runs independently
- Has its own Dockerfile
- Uses MongoDB collections
- Communicates via REST APIs

## 🧰 Tech Stack

### Backend

- Python
- FastAPI
- MongoDB (Motor Async Driver)
- JWT Authentication
- REST APIs (JSON)

### Frontend

- Flutter (Dart)

### DevOps

- Docker
- Kubernetes (Local cluster)
- kubectl
- Docker Desktop

## 🔧 Microservices

### 1️⃣ User Service (Port 8001)

\*\* Responsibilities \*\*

- User registration
- Login authentication
- JWT token generation
- Profile retrieval

\*\* APIs \*\*
• POST /register
• POST /login
• GET /profile

\*\* Stored Data \*\*

- User ID
- Name
- Email
- Hashed Password
- Created Timestamp

Authentication uses JWT tokens.

### 2️⃣ Product Catalog Service (Port 8002)

\*\* Responsibilities \*\*

- Provide product listings
- Category management

\*\* APIs \*\*
• GET /products
• GET /products/{product_id}
• GET /categories

Products are pre-seeded in MongoDB.

### 3️⃣ Cart & Order Service (Port 8003)

\*\* Responsibilities \*\*

- Cart management
- Order creation
- Order history

\*\* APIs \*\*
• POST /cart/add
• DELETE /cart/remove/{cart_id}
• PUT /cart/increase/{cart_id}
• PUT /cart/decrease/{cart_id}
• GET /cart/{user_id}
• POST /order/create
• GET /orders/{user_id}

\*\* Features \*\*

- Quantity merge logic
- Increment / decrement cart items
- Automatic cart clearing after order
- Calls Delivery Service after order creation

### 4️⃣ Delivery & Order Status Service (Port 8004)

\*\* Responsibilities \*\*

- Simulate delivery lifecycle
- Track order status

\*\* Order Status Flow \*\*

PLACED → PACKED → OUT_FOR_DELIVERY → DELIVERED

\*\* APIs \*\*
• GET /order/{order_id}/status
• POST /order/{order_id}/update-status

Order status is automatically initialized when an order is created.

---

## 📱 Flutter Application

### Implemented Screens

✅ Login Screen
✅ Signup Screen
✅ Home Screen (Products)
✅ Cart Screen
✅ Order Confirmation
✅ Order Tracking Screen

### Features

- API integration with all microservices
- Cart quantity controls (+ / −)
- Order placement
- Live order tracking
- Error handling

## 🐳 Docker Setup

Each microservice includes:

- Dockerfile
- Environment configuration
- Independent container execution

Build example:

```bash
docker build -t cart-order-service ./cart-order-service
```

## ☸️ Kubernetes Deployment

All services are deployed using Kubernetes manifests.

- Deploy services

```bash
kubectl apply -f k8s/
```

- Check pods

```bash
kubectl get pods
```

- Port forwarding (example)

```bash
kubectl port-forward service/cart-order-service 8003:8000
```

---

## ▶️ Running the Application

-   1. Start Kubernetes cluster

```bash
(minikube / docker-desktop Kubernetes)
```

-   2. Deploy services

```bash
kubectl apply -f k8s/
```

-   3. Port forward services

| Service | | Port |
| :--- | |:--- |  
|User | |8001 |
|Product | |8002 |
|Cart | |8003 |
|Delivery | |8004 |

-   4. Run Flutter App

```bash
cd quick_commerce_app
flutter pub get
flutter run
```

## 📦 Database Design

- Each service uses isolated collections:

|Service| |Database| |Collection|
|User| |user_db| |users|
|Product| |product_db| |products|
|Cart| |cart_db| |cart_items|
|Order| |cart_db| |orders|
|Delivery| |delivery_db| |order_status|

## ⚙️ Assumptions

• OTP verification uses a hardcoded value (1234)
• No payment gateway integration
• Internal microservice communication is trusted
• Products are pre-seeded

## ⚠️ Known Limitations

• No API Gateway
• No distributed logging
• Delivery status updates are manual
• Minimal UI styling (focus on functionality)

## 🎥 Demo

• User registration & login
• Product browsing
• Cart operations
• Order placement
• Delivery tracking

## Quick Start (Docker Compose)

Run all services locally:

```bash
docker compose up --build
```

### 👨‍💻 Author

Fariduddin Khan
