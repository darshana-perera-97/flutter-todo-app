// lib/screens/loading_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'todo_screen.dart'; // Import the TodoScreen

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 2 seconds, then navigate to TodoScreen
    Timer(Duration(seconds: 2), _navigateToTodoScreen);
  }

  void _navigateToTodoScreen() {
    // Navigate to the TodoScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TodoScreen(),
      ), // Navigate directly to TodoScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0077B5,
      ), // Set background color to #0077B5
      body: Center(
        child: Text(
          'My Todo App', // App name
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
