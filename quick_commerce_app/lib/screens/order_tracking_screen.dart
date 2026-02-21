import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  Future<void> loadStatus() async {
    final data = await ApiService.getOrderStatus(widget.orderId);

    setState(() {
      status = data["status"];
    });
  }

  Widget buildStep(String step) {
    bool completed =
        _statusIndex(status) >= _statusIndex(step);

    return ListTile(
      leading: Icon(
        completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: completed ? Colors.green : Colors.grey,
      ),
      title: Text(step),
    );
  }

  int _statusIndex(String s) {
    const steps = [
      "PLACED",
      "PACKED",
      "OUT_FOR_DELIVERY",
      "DELIVERED"
    ];
    return steps.indexOf(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
        backgroundColor: Colors.deepPurple,
      ),
      body: RefreshIndicator(
        onRefresh: loadStatus,
        child: ListView(
          children: [
            const SizedBox(height: 20),

            Center(
              child: Text(
                "Current Status: $status",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            buildStep("PLACED"),
            buildStep("PACKED"),
            buildStep("OUT_FOR_DELIVERY"),
            buildStep("DELIVERED"),
          ],
        ),
      ),
    );
  }
}