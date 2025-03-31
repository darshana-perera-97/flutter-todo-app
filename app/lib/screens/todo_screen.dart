import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Map<String, dynamic>> goals = [];
  final TextEditingController _todoController = TextEditingController();
  TimeOfDay? selectedTime;

  // Add a new goal
  void addTodo() {
    String task = _todoController.text.trim();
    if (task.isNotEmpty && selectedTime != null) {
      setState(() {
        goals.add({'title': task, 'completed': false, 'time': selectedTime});
        _todoController.clear();
        selectedTime = null;
      });

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter task and pick time")),
      );
    }
  }

  // Toggle checkbox
  void toggleGoal(int index) {
    setState(() {
      goals[index]['completed'] = !goals[index]['completed'];
    });
  }

  // Pick time
  void pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Add Goal Modal
  void _showAddTodoModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Color(0xFFF6F8FF),
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Goal",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _todoController,
                  decoration: InputDecoration(
                    hintText: "Enter your activity",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: pickTime,
                      icon: Icon(Icons.access_time),
                      label: Text("Pick Time"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    if (selectedTime != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          "Selected: ${selectedTime!.format(context)}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Center(
                    child: Text("Add Activity", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Card UI for each todo with accurate remaining time
  Widget todoCard(Map<String, dynamic> goal, int index) {
    final now = DateTime.now();
    final TimeOfDay goalTime = goal['time'];

    final goalDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      goalTime.hour,
      goalTime.minute,
    );

    final duration = goalDateTime.difference(now);
    final int hourLeft = duration.inHours;
    final int minutesLeft = duration.inMinutes % 60;

    String timeFormatted = goalTime.format(context);
    String remainingTime =
        duration.isNegative
            ? "0 hr to goal"
            : "${hourLeft} hr ${minutesLeft} min to goal";

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Checkbox(
            value: goal['completed'],
            onChanged: (_) => toggleGoal(index),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal['title'],
                  style: TextStyle(
                    fontSize: 16,
                    decoration:
                        goal['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                  ),
                ),
                Text(
                  "$remainingTime - $timeFormatted",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int completed = goals.where((g) => g['completed']).length;

    return Scaffold(
      backgroundColor: Color(0xFFF6F8FF),
      appBar: AppBar(
        title: Text('My Goals'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.calendar_today), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: goals.isEmpty ? 0 : completed / goals.length,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  Text(
                    "${goals.isEmpty ? 0 : ((completed / goals.length) * 100).round()}%",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "$completed of ${goals.length} goals completed for today!",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child:
                  goals.isEmpty
                      ? Center(child: Text("No goals yet. Tap + to add one."))
                      : ListView.builder(
                        itemCount: goals.length,
                        itemBuilder:
                            (context, index) => todoCard(goals[index], index),
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: _showAddTodoModal,
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}
