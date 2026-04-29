import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task; // data from database about the task

  const AssignmentDetailScreen({super.key, required this.task});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  double _currentActualHours = 0.0; // Freshly added number

  @override
  void initState() {
    super.initState(); // call the parent class's initState method
    _refreshHours(); // call the method which will read the data
  }

  Future<void> _refreshHours() async {
    final total = await DatabaseHelper.instance.getActualHours(
      widget.task['id'] as int,
    );
    setState(() {
      _currentActualHours = total; // Update the state with the new total hours
    });
  }

  void _showLogTimeDialog(BuildContext context) {
    final TextEditingController hoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Time Log'),
        content: TextField(
          controller: hoursController,
          keyboardType:
              TextInputType.number, // Open numeric keyboard for easier input
          decoration: const InputDecoration(
            labelText: 'Hours spent (e.g., 2.5)',
            hintText: 'Enter hours spent',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final double? enteredHours = double.tryParse(
                hoursController.text,
              );
              if (enteredHours != null && enteredHours > 0) {
                // Call the function form the database helper
                await DatabaseHelper.instance.addTimeLog(
                  widget.task['id'],
                  enteredHours,
                  'Added from detail screen',
                ); // Close the dialog
                if (context.mounted) Navigator.pop(context);
                await _refreshHours(); // Refresh the total hours displayed on the screen
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  // Main build method to construct the UI of the assignment detail screen
  Widget build(BuildContext context) {
    // The basic structure of the screen with an AppBar and a body
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task['title']),
      ), // Display the title of the task in the AppBar
      // The body of the screen is a scrollable area that contains all the details about the assignment
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First card with general information about the assignment
            Card(
              elevation: 4, // Shadow effect for better visual separation
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Display the module name of the assignment with an appropriate icon
                    _buildInfoRow(
                      'Module',
                      widget.task['module_name'],
                      Icons.book,
                    ),
                    // Display the type of the assignment with an appropriate icon
                    _buildInfoRow(
                      'Due Date',
                      widget.task['due_date'],
                      Icons.calendar_today,
                    ),
                    // Display the type of the assignment with an appropriate icon
                    _buildInfoRow(
                      'Status',
                      widget.task['status'],
                      Icons.info_outline,
                    ),
                    // Display weight percentage of the assignment
                    const Divider(),
                    _buildInfoRow(
                      'Weight',
                      '${widget.task['weight_percent']}%',
                      Icons.percent,
                    ),
                    // Display complexity score
                    _buildInfoRow(
                      'Complexity',
                      '${widget.task['complexity_score']}/5',
                      Icons.psychology,
                    ),
                    // Display credits if available, otherwise show 'N/A'
                    _buildInfoRow(
                      'Credits',
                      '${widget.task['credits'] ?? 'N/A'}',
                      Icons.grade,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20), // Spacing between the two cards
            // Second card with estimated and actual hours
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColumnInfo(
                      'Estimated',
                      '${widget.task['estimated_hours']}h', // Get the estimated hours from the task data
                    ),
                    _buildColumnInfo('Actual', '${_currentActualHours}h'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogTimeDialog(context),
        label: const Text('Log Time'),
        icon: Icon(Icons.more_time),
      ),
    );
  }

  // Helper method to build a row of information with an icon, label, and value
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build a column of information for hours
  Widget _buildColumnInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
