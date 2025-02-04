import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/ntrip.dart'; // Import your Ntrip UI

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NTRIP Client',
      theme: ThemeData.dark(), // Apply dark mode (similar to Tailwind)
      home: NtripInterface(), // Set NTRIP UI as the home screen
    );
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: _LoginScreen(),
//     );
//   }
// }

// class _LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<_LoginScreen> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool loading = false;

//   Future<void> login() async {
//     setState(() {
//       loading = true;
//     });

//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:8000/login/'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "username": usernameController.text,
//         "password": passwordController.text,
//       }),
//     );

//     setState(() {
//       loading = false;
//     });

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print("Login successful: ${data['user']}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login successful")),
//       );
//     } else {
//       print("Error: ${response.body}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid credentials")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("City Data Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: usernameController,
//               decoration: InputDecoration(labelText: "Username"),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             loading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           Colors.blue.shade500, // Tailwind's 'blue-900'
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                     ),
//                     onPressed: login,
//                     child: Text("Login", style: TextStyle(color: Colors.white)),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
