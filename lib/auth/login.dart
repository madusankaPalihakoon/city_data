import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../interface/home.dart'; // Import the HomeScreen
import '../services/bluetooth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    final response = await http.post(
      Uri.parse('https://vertextback.geoinfobox.com/api/user/login/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": usernameController.text,
        "password": passwordController.text,
      }),
    );

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Login successful: ${data['user']}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Login successful: ${data['user']['display_name']}")),
      );
      // Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DeviceScreen()), // Add this line
        // MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print("Error: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("City Data",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: "Username", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
              ),
              SizedBox(height: 20),
              loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      onPressed: login,
                      child:
                          Text("Login", style: TextStyle(color: Colors.white)),
                    ),
              TextButton(
                onPressed: () {},
                child: Text("Create Account",
                    style: TextStyle(color: Colors.blue.shade500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
