import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data = await ApiService.getProducts();
    setState(() {
      products = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Quick Commerce"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                    return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                            onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(product: product),
                                ),
                            );
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text(
                                                        product["name"],
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                        ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(
                                                        "₹${product["price"]}",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.grey,
                                                        ),
                                                    ),
                                                ],
                                            ),

                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.deepPurple,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 20, vertical: 10),
                                                    shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    ),
                                                ),
                                                onPressed: () async {
                                                    await ApiService.addToCart(
                                                        "user123", product["_id"]);

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                        content: Text("Added to cart 🛒")),
                                                    );
                                                },
                                                child: const Text(
                                                    "Add",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                            )
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    );
                },
              ),
            ),
        );
    }
}