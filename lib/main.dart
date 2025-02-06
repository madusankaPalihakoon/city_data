import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth/login.dart'; // Import the LoginScreen
// import 'services/ntrip.dart'; // Import your Ntrip UI

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "City Data",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Use LoginScreen as the home screen
    );
  }
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'NTRIP Client',
//       theme: ThemeData.dark(), // Apply dark mode (similar to Tailwind)
//       home: NtripInterface(), // Set NTRIP UI as the home screen
//     );
//   }
// }
