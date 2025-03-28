// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/loading_screen.dart'; // Import the LoadingScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingScreen(), // Set LoadingScreen as the home screen
      debugShowCheckedModeBanner: false, // This line removes the debug banner
    );
  }
}
