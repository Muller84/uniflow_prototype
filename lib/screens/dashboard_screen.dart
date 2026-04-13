import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'assignment_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Function to get color based on status
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

  // Function to build a card for each task
  Widget _buildCard(BuildContext context, Map<String, dynamic> task) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentDetailScreen(task: task),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: ListTile(
          title: Text(
            task['title'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Module: ${task['module_name']}'),
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
      ),

      // Use FutureBuilder to fetch and display tasks
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getAllAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator while fetching data
          }
          // if is data is empty, show a message
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assignments found.'));
          }

          final tasks = snapshot.data!;
          Map<String, List<Map<String, dynamic>>> grouped = {};
          // Group tasks by year and semester
          for (var t in tasks) {
            String key = "Year ${t['year']} - ${t['semester']}";
            grouped.putIfAbsent(key, () => []).add(t);
          }

          // Build a CustomScrollView with SliverPersistentHeader for each group
          return CustomScrollView(
            slivers: grouped.keys.map((headerTitle) {
              // For each group, create a SliverMainAxisGroup that contains a pinned header and a list of cards
              return SliverMainAxisGroup(
                slivers: [
                  // pinned header that shows the group title (year and semester)
                  SliverPersistentHeader(
                    pinned: true, // TADY JE TO KOUZLO - díky tomu to "lepí"
                    delegate: _HeaderDelegate(title: headerTitle),
                  ),
                  // list of cards for each task in the group
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
