import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'provider_screen.dart';
import 'request_screen.dart';
import 'user_screen.dart';

class NavItem {
  final String label;
  final String iconPath;
  final String route;

  NavItem({required this.label, required this.iconPath, required this.route});
}

class AdminNavGraph extends StatefulWidget {
  const AdminNavGraph({super.key});

  @override
  _AdminNavGraphState createState() => _AdminNavGraphState();
}

class _AdminNavGraphState extends State<AdminNavGraph> {
  int _selectedIndex = 0;

  final List<NavItem> _navItems = [
    NavItem(label: 'Dashboard', iconPath: 'assets/images/data.png', route: 'dashboard'),
    NavItem(label: 'Users', iconPath: 'assets/images/multiple.png', route: 'users'),
    NavItem(label: 'Requests', iconPath: 'assets/images/quote.png', route: 'requests'),
    NavItem(label: 'Providers', iconPath: 'assets/images/employee.png', route: 'providers'),
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
                    backgroundColor: const Color(0xFF86D069),
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
        return const DashboardScreen();
      case 1:
        return const UserScreen();
      case 2:
        return const RequestScreen();
      case 3:
        return const ProviderScreen();
      default:
        return const DashboardScreen();
    }
  }
}