import 'package:flutter/material.dart';

class AssignmentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  const AssignmentDetailScreen({super.key, required this.task});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task['title'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Main card with the most important data
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Module', task['module_name'], Icons.book),
                    _buildInfoRow(
                      'Due Date',
                      task['due_date'],
                      Icons.calendar_today,
                    ),
                    _buildInfoRow('Status', task['status'], Icons.info_outline),
                    const Divider(),
                    _buildInfoRow(
                      'Weight',
                      '${task['weight_percent']}%',
                      Icons.percent,
                    ),
                    _buildInfoRow(
                      'Complexity',
                      '${task['complexity_score']}/5',
                      Icons.psychology,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Section for hours
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColumnInfo(
                      'Estimated',
                      '${task['estimated_hours']}h',
                    ),
                    _buildColumnInfo('Actual', '${task['actual_hours']}h'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
