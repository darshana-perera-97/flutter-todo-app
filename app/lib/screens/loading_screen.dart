import 'dart:async';
import 'package:flutter/material.dart';
import 'todo_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), _navigateToTodoScreen);
  }

  void _navigateToTodoScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TodoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0077B5),
      body: Center(
        child: Text(
          'My Todo App',
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
