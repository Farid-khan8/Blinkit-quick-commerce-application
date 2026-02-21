import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLoading = false;

  Future<void> addToCart() async {
    setState(() => isLoading = true);

    try {
    //   await ApiService.addToCart(
    //     productId: widget.product["_id"],
    //     quantity: 1,
    //   );
        await ApiService.addToCart(
            "user123",
            widget.product["_id"],
        );

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Added to cart ✅")),
        );
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to add item")),
        );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Image Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shopping_bag, size: 80),
            ),

            const SizedBox(height: 20),

            /// Product Name
            Text(
              product["name"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// Price
            Text(
              "₹${product["price"]}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.deepPurple,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            /// Description (fallback text)
            const Text(
              "Fresh product delivered instantly. "
              "High quality groceries available for quick delivery.",
              style: TextStyle(fontSize: 15),
            ),

            const Spacer(),

            /// Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}