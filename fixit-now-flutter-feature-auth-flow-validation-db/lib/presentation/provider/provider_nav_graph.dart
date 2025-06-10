import 'package:flutter/material.dart';
import 'my_jobs_screen.dart';
import 'profile_and_setting_screen.dart';
import 'performance_screen.dart';
import 'job_request_screen.dart';

class NavItem {
  final String label;
  final String iconPath;
  final String route;

  const NavItem({required this.label, required this.iconPath, required this.route});
}

class ProviderNavGraph extends StatefulWidget {
  const ProviderNavGraph({super.key});

  @override
  _ProviderNavGraphState createState() => _ProviderNavGraphState();
}

class _ProviderNavGraphState extends State<ProviderNavGraph> {
  int _selectedIndex = 0;

  final List<NavItem> _navItems = const [
    NavItem(label: 'application', iconPath: 'assets/images/application.png', route: 'application'),
    NavItem(label: 'suitcase', iconPath: 'assets/images/suitcase.png', route: 'suitcase'),
    NavItem(label: 'management', iconPath: 'assets/images/management.png', route: 'management'),
    NavItem(label: 'user', iconPath: 'assets/images/user.png', route: 'user'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC4D8DA),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'FixItNow',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900, // Bolder font weight
          ),
        ),
        centerTitle: true,
        actions: const [], // Removed logout icon
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFBABABA), // Set drawer background to #BABABA
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF86D069),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Contact Us'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email: support@fixitnow.com'),
                            const SizedBox(height: 8),
                            const Text('Phone: +251 911 123 456'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Contact Us'),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('Sign Out'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: _buildContentScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: _navItems
              .asMap()
              .entries
              .map((entry) => BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedIndex == entry.key ? const Color(0xFF4A6572) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        entry.value.iconPath,
                        width: 24,
                        height: 24,
                        color: _selectedIndex == entry.key ? Colors.white : Colors.black54,
                      ),
                    ),
                    label: entry.value.label,
                    backgroundColor: Colors.white,
                  ))
              .toList(),
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF4A6572),
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildContentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const JobRequestScreen();
      case 1:
        return const MyJobsScreen();
      case 2:
        return const PerformanceScreen();
      case 3:
        return const ProfileAndSettingScreen();
      default:
        return const JobRequestScreen();
    }
  }
}