import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../services/database_helper.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const AssignmentDetailScreen({super.key, required this.task});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  double _currentActualHours = 0.0;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.task['status'];
    _refreshHours();
  }

  Future<void> _refreshHours() async {
    final total = await DatabaseHelper.instance.getActualHours(
      widget.task['id'] as int,
    );
    setState(() {
      _currentActualHours = total;
    });
  }

  void _updateStatus(String newStatus) async {
    await DatabaseHelper.instance.updateAssignmentStatus(
      widget.task['id'] as int,
      newStatus,
    );
    setState(() {
      _currentStatus = newStatus;
    });
  }

  void _showLogTimeDialog(BuildContext context) {
    final TextEditingController hoursController = TextEditingController();
    final TextEditingController noteController =
        TextEditingController(); // Definice zde

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Time Log'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Hours spent (e.g., 2.5)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'What did you work on?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final double? enteredHours = double.tryParse(
                hoursController.text,
              );
              if (enteredHours != null && enteredHours > 0) {
                // VOLÁNÍ DATABÁZE - ujisti se, že addTimeLog přijímá tyto 3 argumenty
                await DatabaseHelper.instance.addTimeLog(
                  widget.task['id'],
                  enteredHours,
                  noteController.text.isEmpty ? 'No note' : noteController.text,
                );
                if (context.mounted) Navigator.pop(context);
                await _refreshHours();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task['title'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Module',
                      widget.task['module_name'],
                      Icons.book,
                    ),
                    _buildInfoRow(
                      'Due Date',
                      widget.task['due_date'],
                      Icons.calendar_today,
                    ),
                    _buildInfoRow(
                      'Status',
                      _currentStatus,
                      Icons.info_outline,
                      trailing: DropdownButton<String>(
                        underline: Container(),
                        icon: const Icon(Icons.edit, size: 16),
                        items: ['Planned', 'In Progress', 'Done'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) _updateStatus(newValue);
                        },
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      'Weight',
                      '${widget.task['weight_percent']}%',
                      Icons.percent,
                    ),
                    _buildInfoRow(
                      'Complexity',
                      '${widget.task['complexity_score']}/5',
                      Icons.psychology,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColumnInfo(
                      'Estimated',
                      '${widget.task['estimated_hours']}h',
                    ),
                    _buildColumnInfo('Actual', '${_currentActualHours}h'),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_sweep,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteLastLog(
                          widget.task['id'],
                        );
                        await _refreshHours();
                      },
                    ),
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
        icon: const Icon(Icons.more_time),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
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
          ),
          if (trailing != null) trailing,
        ],
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
