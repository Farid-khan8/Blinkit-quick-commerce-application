import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String userBase = "http://localhost:8001";
  static const String productBase = "http://localhost:8002";
  static const String cartBase = "http://localhost:8003";
  static const String deliveryBase = "http://localhost:8004";

  // REGISTER
  static Future<void> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$userBase/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "otp": "1234"
      }),
    );

    // print("Register Status: ${response.statusCode}");
    // print("Register Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data["detail"] ?? "Registration failed");
    }
  }

  // PRODUCTS
  static Future<List<dynamic>> getProducts() async {
    final response =
        await http.get(Uri.parse("$productBase/products"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load products");
    }
  }

  // ADD TO CART
  static Future<void> addToCart(String userId, String productId) async {
    final response = await http.post(
        Uri.parse("$cartBase/cart/add"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
            "user_id": userId,
            "product_id": productId,
            "quantity": 1
        }),
    );

    print("Add Status: ${response.statusCode}");
    print("Add Body: ${response.body}");

    if (response.statusCode != 200) {
        throw Exception("Failed to add to cart");
    }
  }

  // GET CART (FIXED)
  static Future<List<dynamic>> getCart(String userId) async {
    final response =
        await http.get(Uri.parse("$cartBase/cart/$userId"));

    print("Cart Status: ${response.statusCode}");
    print("Cart Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load cart");
    }
  }

  // CREATE ORDER
//   static Future<void> createOrder(String userId) async {
//     final response = await http.post(
//       Uri.parse("$cartBase/order/create"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "user_id": userId,
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception("Order creation failed");
//     }
//   }
    static Future<Map<String, dynamic>> createOrder(String userId) async {
        final response = await http.post(
            Uri.parse("$cartBase/order/create"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"user_id": userId}),
        );

        if (response.statusCode == 200) {
            return jsonDecode(response.body);
        } else {
            throw Exception("Order creation failed");
        }
    }

  // REMOVE FROM CART
    static Future<void> removeFromCart(String cartId) async {
        final response = await http.delete(
            Uri.parse("$cartBase/cart/remove/$cartId"),
        );

        print("Delete Status: ${response.statusCode}");
        print("Delete Body: ${response.body}");

        if (response.statusCode != 200) {
            throw Exception("Failed to remove item");
        }
    }

    // INCREASE QUANTITY
    static Future<void> increaseQuantity(String cartId) async {
        final response = await http.put(
            Uri.parse("$cartBase/cart/increase/$cartId"),
        );

        if (response.statusCode != 200) {
            throw Exception("Failed to increase quantity");
        }
    }

    // DECREASE QUANTITY
    static Future<void> decreaseQuantity(String cartId) async {
        final response = await http.put(
            Uri.parse("$cartBase/cart/decrease/$cartId"),
        );

        if (response.statusCode != 200) {
            throw Exception("Failed to decrease quantity");
        }
    }

    //ORDER STATUS
    static Future<Map<String, dynamic>> getOrderStatus(String orderId) async {
        final response = await http.get(
            Uri.parse("$deliveryBase/order/$orderId/status"),
        );

        if (response.statusCode == 200) {
            return jsonDecode(response.body);
        } else {
            throw Exception("Failed to fetch order status");
        }
    }
}