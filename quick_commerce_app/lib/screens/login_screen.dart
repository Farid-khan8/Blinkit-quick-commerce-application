import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void registerUser() async {
    try {
      await ApiService.register(
        "Farid",
        emailController.text,
        passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
    );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quick Commerce Login")),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            const Text(
                                "Welcome Back 👋",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(height: 30),
                            TextField(
                            controller: emailController,
                                decoration: InputDecoration(
                                    labelText: "Email",
                                    border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    ),
                                ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                            controller: passwordController,
                            obscureText: true,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    ),
                                ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                            width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                    ),
                                    ),
                                    onPressed: registerUser,
                                    child: const Text(
                                    "Register & Continue",
                                    style: TextStyle(fontSize: 16),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
    );
  }
}