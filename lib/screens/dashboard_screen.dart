import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'assignment_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// Constant color
const Color togglDark = Color(0xFF2C1338);
const Color togglPink = Color(0xFFE57CD8);
const Color togglLightPurple = Color(0xFFFCEBFA);

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
        return const Color.fromRGBO(71, 15, 69, 1);
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
        color: togglLightPurple, // Light purple background for the card
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
          // Display the title and status
          title: Text(
            task['title'],
            style: const TextStyle(fontWeight: FontWeight.bold),
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
    const Color togglDark = Color(0xFF2C1338);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: togglDark,
        surfaceTintColor: togglDark, // Remove default shadow
        elevation: 0, // Subtle shadow for separation
        toolbarHeight: 80, // Increased height for better spacing
        automaticallyImplyLeading: false, // Remove default back button

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: togglPink, // Light grey line for separation
            height: 2,
          ),
        ),

        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: togglPink, // Navy blue background for the icon
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ], // Rounded corners
              ),
              child: const Icon(
                Icons.school,
                color: Colors.white,
                size: 28,
              ), // University icon
            ),
            // University icon
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UniFlow',
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: togglPink,
                      letterSpacing: -1.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2),
                  Text(
                    'PERSONAL ACADEMIC INFORMATION SYSTEM',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Refresh button in the app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: togglPink,
            iconSize: 28,
            onPressed: () {
              _loadData(); // Reload data when refresh button is pressed
            },
          ),

          const SizedBox(width: 15),

          const Icon(
            Icons.account_circle_outlined,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Center(
            child: Text(
              'Alex',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 30),
        ],
      ), // AppBar
      // Main Header with listed information
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
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    15,
                    24,
                    15,
                  ), // Left, Top, Right, Bottom padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Good Morning, Alex!',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Academic Overview:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...grouped.keys.toList().reversed.map((headerTitle) {
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
              }),
            ],
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      // Pozadí necháme světlé, aby to ladilo k tělu aplikace
      color: const Color.fromRGBO(243, 236, 239, 1),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          // Použijeme tvůj nový font
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: togglPink, // Tady ta růžová vypadá jako skvělý akcent
          letterSpacing: 1.2,
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
