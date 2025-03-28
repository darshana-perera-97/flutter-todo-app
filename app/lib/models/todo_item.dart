// models/todo_item.dart

import 'package:flutter/material.dart';

class TodoItem {
  String title;
  String description;
  DateTime deadline;
  bool isDone;
  DateTime dateTime;

  TodoItem({
    required this.title,
    required this.description,
    required this.deadline,
    this.isDone = false,
    required this.dateTime,
  });
}
