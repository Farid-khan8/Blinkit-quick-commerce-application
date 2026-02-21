import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/order_tracking_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() async {
    final data = await ApiService.getCart("user123");
    setState(() {
      cartItems = data;
      isLoading = false;
    });
  }

  double calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
        final price = item["price"] ?? 0;
        final quantity = item["quantity"] ?? 0;
        total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty 🛒"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];

                          return Card(
                            margin: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(item["name"] ?? "Unknown Product"),
                                subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text("₹${item["price"]}"),
                                        Row(
                                        children: [
                                            IconButton(
                                            icon: const Icon(Icons.remove_circle_outline),
                                            onPressed: () async {
                                                await ApiService.decreaseQuantity(item["_id"]);
                                                loadCart();
                                            },
                                            ),
                                            Text(
                                                "${item["quantity"]}",
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                                icon: const Icon(Icons.add_circle_outline),
                                                onPressed: () async {
                                                    await ApiService.increaseQuantity(item["_id"]);
                                                    loadCart();
                                                },
                                            ),
                                        ],
                                        )
                                    ],
                                ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                            BoxShadow(
                                blurRadius: 12,
                                color: Colors.black12,
                            )
                            ],
                        ),
                        child: Column(
                            children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                const Text(
                                    "Total",
                                    style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    ),
                                ),
                                Text(
                                    "₹${calculateTotal().toStringAsFixed(0)}",
                                    style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                                ],
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 6,
                                ),
                                onPressed: () async {
                                    // await ApiService.createOrder("user123");
                                    final order = await ApiService.createOrder("user123");
                                    
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            OrderTrackingScreen(orderId: order["order_id"]),
                                    ),
                                    );
                                    loadCart();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Order placed successfully 🎉"),
                                    ),
                                    );
                                },
                                child: const Text(
                                    "Place Order",
                                    style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    ),
                                ),
                                ),
                            )
                            ],
                        ),
                        ),


                  ],
                ),
    );
  }
}