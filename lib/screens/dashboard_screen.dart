import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'assignment_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'package:uniflow/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart'; // for opening the college website
import 'package:fl_chart/fl_chart.dart'; // for the graph

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Proměnná slouží k vynucení reloadu FutureBuilderu
  late Future<List<Map<String, dynamic>>> _assignmentsFuture;

  // Promenné pro graf
  Map<int, Map<String, int>> _doneTypes = {};
  List<int> _months = [];

  // Proměnná pro zobrazení počtu úkolů s blížícím se deadline v top kartě
  List<Map<String, dynamic>> _deadlineTasks = [];

  // Proměnná pro zobrazení posledních 3 úkolů v top kartě Workload
  List<Map<String, dynamic>> _lastTasks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Načteme data pro FutureBuilder
    setState(() {
      _assignmentsFuture = DatabaseHelper.instance.getAllAssignments();
    });
    // Načteme data pro graf
    DatabaseHelper.instance.getFormativeSummativeLast90Days().then((data) {
      setState(() {
        _doneTypes = data;
        _months = data.keys.toList(); // např. [2,3,4]
      });
    });
    // Načteme data pro zobrazení počtu úkolů s blížícím se deadline v top kartě
    DatabaseHelper.instance.getUpcomingDeadlines().then((data) {
      setState(() {
        _deadlineTasks = data;
      });
    });
    // Načteme data pro zobrazení posledních 3 úkolů v top kartě Workload
    DatabaseHelper.instance.getLastThreeTasks().then((data) {
      setState(() {
        _lastTasks = data;
      });
    });

    print("DONE last 90 days: $_doneTypes");
    print("MONTHS: $_months");
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return uniAccentGreen; // Dark purple for completed tasks
      case 'In Progress':
        return uniAccentYellow; // Bright yellow for tasks in progress
      case 'Planned':
        return uniAccentCoral; // Light coral for planned tasks
      default:
        return Colors.grey;
    }
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> task) {
    bool isFormative = task['type'] == 'Feedback';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentDetailScreen(task: task),
          ),
        ).then((_) => _loadData());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ICON
            CircleAvatar(
              backgroundColor: isFormative
                  ? uniAccentBlue.withValues(alpha: 0.15)
                  : uniPrimary.withValues(alpha: 0.15),
              child: Icon(
                isFormative ? Icons.lightbulb_outline : Icons.assignment,
                color: isFormative ? uniAccentBlue : uniPrimary,
              ),
            ),

            const SizedBox(width: 16),

            // TEXTS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'],
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: uniPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Module: ${task['module_name']}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Logged: ${task['actual_hours']}h / Est: ${task['estimated_hours']}h',
                    style: TextStyle(
                      fontSize: 12,
                      color: (task['actual_hours'] > task['estimated_hours'])
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // STATUS DOT
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor(task['status']),
              ),
            ),
          ],
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
        backgroundColor: uniPrimary, // Navy blue background for the app bar
        surfaceTintColor: uniPrimary, // Remove default shadow
        elevation: 0, // Subtle shadow for separation
        toolbarHeight: 80, // Increased height for better spacing
        automaticallyImplyLeading: false, // Remove default back button

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color:
                uniAccentBlue, // Light blue accent line at the bottom of the app bar
            height: 2,
          ),
        ),

        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: uniAccentBlue, // Light blue background for the icon
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
                  // Title with custom font and styling
                  Text(
                    'UniFlow',
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color:
                          uniAccentBlue, // Light blue accent color for the title
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

                  SizedBox(
                    height: 2,
                  ), // Small spacing between title and subtitle
                  // Subtitle with smaller font and lighter color
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
          // REFRESH + TOOLTIP
          Tooltip(
            message: "Reload data",
            child: IconButton(
              icon: const Icon(Icons.refresh),
              color: uniAccentBlue,
              iconSize: 25,
              onPressed: () {
                _loadData();
              },
            ),
          ),

          const SizedBox(width: 30),

          // B&FC LINK + TOOLTIP
          Tooltip(
            message: "Visit B&FC website",
            child: IconButton(
              icon: const Icon(Icons.public),
              color: Colors.white,
              onPressed: () async {
                final url = Uri.parse("https://www.blackpool.ac.uk");
                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception("Could not launch $url");
                }
              },
            ),
          ),

          const SizedBox(width: 30),

          // ACCOUNT + TOOLTIP
          Tooltip(
            message: "Account / Logout",
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.white24,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Alex',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
                      // Greeting text with custom font and styling
                      const Text(
                        'Good Morning, Alex!',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      // Subtext with smaller font and lighter color
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              // Přidání sekce s top kartami a grafem
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TOP CARDS
                      Row(
                        children: [
                          Expanded(
                            child: _buildTopCard('Workload', Icons.work),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTopCard(
                              'Risk',
                              Icons.warning_amber_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTopCard(
                              'Deadlines',
                              Icons.calendar_month,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // GRAPH
                      Text(
                        'Workload Chart',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: togglDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your DONE tasks from the past 3 months — nice work so far!',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for the graph
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.2,
                              ), // Subtle shadow for depth
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ], // Shadow for depth
                        ),
                        padding: const EdgeInsets.all(16),
                        // Graf pro zobrazení workloadu za poslední 3 měsíce
                        child: BarChart(
                          BarChartData(
                            // Nastavení tooltipů pro zobrazení detailů při tapnutí na sloupec
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.black87,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                      final month = _months[group.x.toInt()];
                                      final values =
                                          _doneTypes[month] ??
                                          {"formative": 0, "summative": 0};

                                      if (rodIndex == 0) {
                                        return BarTooltipItem(
                                          "Formative: ${values["formative"]}",
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        return BarTooltipItem(
                                          "Summative: ${values["summative"]}",
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
                              ),
                            ),

                            // Skryje osy a mřížku pro čistší vzhled
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  // Zobrazí názvy měsíců na ose X, např. "Jan", "Feb", "Mar"
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() < 0 ||
                                        value.toInt() >= _months.length) {
                                      return const SizedBox();
                                    }

                                    final month = _months[value.toInt()];
                                    const names = [
                                      "Jan",
                                      "Feb",
                                      "Mar",
                                      "Apr",
                                      "May",
                                      "Jun",
                                      "Jul",
                                      "Aug",
                                      "Sep",
                                      "Oct",
                                      "Nov",
                                      "Dec",
                                    ];

                                    return Text(names[month - 1]);
                                  },
                                ),
                              ),
                            ),

                            // Vytvoření dat pro sloupce grafu na základě načtených dat
                            barGroups: List.generate(_months.length, (index) {
                              final month = _months[index];
                              final values =
                                  _doneTypes[month] ??
                                  {"formative": 0, "summative": 0};
                              final formative = values["formative"] ?? 0;
                              final summative = values["summative"] ?? 0;
                              return BarChartGroupData(
                                x: index,
                                barsSpace: 12,
                                barRods: [
                                  BarChartRodData(
                                    toY: formative.toDouble(),
                                    color: uniAccentBlue,
                                    width: 12,
                                  ),
                                  BarChartRodData(
                                    toY: summative.toDouble(),
                                    color: uniPrimary,
                                    width: 12,
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              // Zobrazeni jednotlivych skupin úkolů podle roku a semestru
              ...grouped.keys.toList().reversed.map((headerTitle) {
                return SliverMainAxisGroup(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _HeaderDelegate(title: headerTitle),
                    ),
                    // Legenda pro barvy statusů úkolů
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildLegendDot(uniAccentGreen, 'Done'),
                            SizedBox(width: 12),
                            _buildLegendDot(uniAccentYellow, 'In Progress'),
                            SizedBox(width: 12),
                            _buildLegendDot(uniAccentCoral, 'Planned'),
                          ],
                        ),
                      ),
                    ),
                    // Seznam úkolů pro danou skupinu
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

  // Helper method to build the top cards with consistent styling
  Widget _buildTopCard(String title, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: uniAccentBlue, size: 28),
            const SizedBox(height: 10),
            if (title !=
                "Workload") // Pro karty Risk a Deadlines zobrazím jen název a počet úkolů
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  color: uniPrimary,
                ),
              ),

            // ⭐ Pokud je to Workload → zobrazím poslední 3 summative
            if (title == "Workload") ...[
              Text(
                'Upcoming Workload Snapshot',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: uniPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Estimated vs Actual hours for your recent formative & summative tasks',
                style: TextStyle(fontSize: 11, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),

              ..._lastTasks.map((task) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task['title'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "Est: ${task['estimated_hours']}h",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Act: ${task['actual_hours']}h",
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              (task['actual_hours'] > task['estimated_hours'])
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            // Pokud je to Risk
            if (title == "Risk") ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: uniAccentGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: uniAccentGreen, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "No current risks",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: uniAccentGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ⭐ Pokud je to Deadlines → zobrazím počet úkolů, které jsou deadline
            if (title == "Deadlines") ...[
              const SizedBox(height: 12),

              ..._deadlineTasks.map((task) {
                final dueDate = DateTime.parse(task['due_date']);
                final now = DateTime.now();
                final diff = dueDate.difference(now).inDays;

                String label;
                if (diff == 0) {
                  label = "Due today";
                } else if (diff == 1) {
                  label = "Due tomorrow";
                } else {
                  label = "Due in $diff days";
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task['title'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method to build legend dots for the graph
  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.black54)),
      ],
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
      // background for header
      color: uniBackground,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          // Použijeme tvůj nový font
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: uniAccentBlue,
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
