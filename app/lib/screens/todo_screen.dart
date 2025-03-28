import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import DateFormat class
import '../models/todo_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> _todoList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDeadline;

  void _addTodoItem(String title, String description, DateTime deadline) {
    if (title.isNotEmpty && description.isNotEmpty && deadline != null) {
      setState(() {
        _todoList.add(
          TodoItem(
            title: title,
            description: description,
            deadline: deadline,
            dateTime: DateTime.now(),
          ),
        );
      });
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedDeadline = null;
      });
      Navigator.pop(context);
    }
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 40), // Increase width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Popup Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0077B5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Center(
                  child: Text(
                    'Add New Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Task Title Input
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _titleController,
                  cursorColor: const Color(0xFF0077B5),
                  decoration: InputDecoration(
                    hintText: 'Enter task title...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF0077B5),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // Task Description Input (Text Area)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4, // Make it a multi-line text area
                  cursorColor: const Color(0xFF0077B5),
                  decoration: InputDecoration(
                    hintText: 'Enter task description...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF0077B5),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // DatePicker for Deadline
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedDeadline = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0077B5),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _selectedDeadline == null
                          ? 'Select Deadline'
                          : DateFormat(
                            'MMM d, h:mm a',
                          ).format(_selectedDeadline!),
                      style: TextStyle(
                        color:
                            _selectedDeadline == null
                                ? Colors.grey
                                : const Color(0xFF0077B5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _titleController.clear();
                        _descriptionController.clear();
                        setState(() {
                          _selectedDeadline = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          () => _addTodoItem(
                            _titleController.text,
                            _descriptionController.text,
                            _selectedDeadline!,
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0077B5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todoList[index].isDone = !_todoList[index].isDone;
    });
  }

  void _deleteTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM d, h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 To-Do List'),
        backgroundColor: const Color(0xFF0077B5),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "What's on your list today?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077B5),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  _todoList.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'No tasks added yet!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: _todoList.length,
                        itemBuilder: (context, index) {
                          final todo = _todoList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF0077B5),
                                width: 2, // Set border color
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0077B5),
                                  decoration:
                                      todo.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    todo.description,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDate(todo.dateTime),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      todo.isDone
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: const Color(0xFF0077B5),
                                    ),
                                    onPressed: () => _toggleTodoStatus(index),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: const Color(0xFF0077B5),
                                    ),
                                    onPressed: () => _deleteTodoItem(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: const Color(0xFF0077B5),
        child: const Icon(Icons.add),
      ),
    );
  }
}
