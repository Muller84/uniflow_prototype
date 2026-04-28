import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'assignment_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Proměnná slouží k vynucení reloadu FutureBuilderu
  late Future<List<Map<String, dynamic>>> _assignmentsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _assignmentsFuture = DatabaseHelper.instance.getAllAssignments();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Planned':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> task) {
    // Logic for formative vs summative tasks
    bool isFormative = task['type'] == 'Feedback';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentDetailScreen(task: task),
          ),
        ).then((_) {
          // Když se vrátím z detailu, Dashboard se znovu načte
          _loadData();
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        elevation: 2, // Shadow for better visual separation
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isFormative
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.orange.withValues(alpha: 0.1),
            child: Icon(
              isFormative ? Icons.lightbulb_outline : Icons.assignment,
              // Icon color based on task type
              color: isFormative ? Colors.blue : Colors.orange,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  task['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isFormative ? Colors.blue[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isFormative
                        ? Colors.blue[200]!
                        : Colors.orange[200]!,
                  ),
                ),
                child: Text(
                  isFormative ? 'FORMATIVE' : 'SUMMATIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isFormative ? Colors.blue[700] : Colors.orange[800],
                  ),
                ),
              ),
            ],
          ), // Favicon pro typ úkolu
          // Přidání Actual vs Estimated hodin přímo do podnadpisu
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Module: ${task['module_name']}'),
              const SizedBox(height: 4),
              Text(
                'Logged: ${task['actual_hours']}h / Est: ${task['estimated_hours']}h',
                style: TextStyle(
                  fontSize: 12,
                  color: (task['actual_hours'] > task['estimated_hours'])
                      ? Colors
                            .red // Overtime warning
                      : Colors.grey[700], // Standard color for hours
                ),
              ),
            ],
          ),
          trailing: Text(
            task['status'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getStatusColor(task['status']),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniFlow Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData, // Manuální refresh tlačítko
          ),
          const SizedBox(width: 40),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _assignmentsFuture, // Používám proměnnou z initState
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assignments found.'));
          }

          final tasks = snapshot.data!;
          Map<String, List<Map<String, dynamic>>> grouped = {};
          for (var t in tasks) {
            String key = "Year ${t['year']} - ${t['semester']}";
            grouped.putIfAbsent(key, () => []).add(t);
          }

          return CustomScrollView(
            slivers: grouped.keys.map((headerTitle) {
              return SliverMainAxisGroup(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _HeaderDelegate(title: headerTitle),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) =>
                          _buildCard(context, grouped[headerTitle]![i]),
                      childCount: grouped[headerTitle]!.length,
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate to create a pinned header for each group
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  _HeaderDelegate({required this.title});

  @override
  // Build the header widget that will be pinned at the top of the screen
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50; // The maximum height of the header when it's fully expanded
  @override
  double get minExtent => 50; // The minimum height of the header when it's fully collapsed (same as maxExtent to keep it fixed)
  @override
  // This method determines whether the header should be rebuilt when the delegate changes. We want to rebuild if the title changes.
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) =>
      title != oldDelegate.title;
}
