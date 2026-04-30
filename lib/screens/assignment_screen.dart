import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniflow/theme/colors.dart';
import '../services/database_helper.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const AssignmentDetailScreen({super.key, required this.task});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  double _currentActualHours = 0.0;
  String? _lastNote; // Last note
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
    // Fetch the last note for this task
    final lastNote = await DatabaseHelper.instance.getLastNote(
      widget.task['id'] as int,
    );
    setState(() {
      _currentActualHours = total;
      _lastNote = lastNote;
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
                // call database helper to add log
                await DatabaseHelper.instance.addTimeLog(
                  widget.task['id'],
                  enteredHours,
                  noteController.text.isEmpty ? 'No note' : noteController.text,
                );
                setState(() {
                  _lastNote = noteController.text.isEmpty
                      ? 'No note'
                      : noteController.text; // Save last note to state
                });
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
      appBar: AppBar(
        backgroundColor: togglDark,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.task['title'],
          style: GoogleFonts.outfit(
            color: togglPink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                        dropdownColor: togglLightPurple,
                        iconEnabledColor: togglPink,
                        style: TextStyle(
                          color: togglDark,
                          fontWeight: FontWeight.w500,
                        ),
                        icon: const Icon(
                          Icons.edit_note,
                          size: 20,
                          color: togglPink,
                        ),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildColumnInfo(
                          'Estimated',
                          '${widget.task['estimated_hours']}h',
                        ),
                        _buildColumnInfo('Actual', '${_currentActualHours}h'),
                        IconButton(
                          tooltip: 'Delete Last Entry',
                          icon: const Icon(
                            Icons.delete_sweep,
                            color: togglPink,
                            size: 25,
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
                    if (_lastNote != null && _lastNote!.isNotEmpty) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          ' Last note: $_lastNote',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogTimeDialog(context),
        label: const Text('Log Time + Note'),
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
          CircleAvatar(
            radius: 16,
            backgroundColor: togglPink.withValues(alpha: 0.1),
            child: Icon(icon, size: 16, color: togglPink),
          ),
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
