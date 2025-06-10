import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/token_service.dart';
import 'my_requests_screen.dart';
import 'profile_screen.dart';
import 'recruitment_screen.dart';
import 'request_service_screen.dart';

class NavItem {
  final String label;
  final String iconPath;
  final String route;

  const NavItem({
    required this.label,
    required this.iconPath,
    required this.route,
  });
}

class UserNavGraph extends StatefulWidget {
  const UserNavGraph({super.key});

  @override
  State<UserNavGraph> createState() => _UserNavGraphState();
}

class _UserNavGraphState extends State<UserNavGraph> {
  int _selectedIndex = 0;
  final _authService = AuthService();
  final _tokenService = TokenService();
  int? _requesterId;

  final List<NavItem> _navItems = const [
    NavItem(label: 'Dashboard', iconPath: 'assets/images/recruitment.png', route: 'dashboard'),
    NavItem(label: 'Requests', iconPath: 'assets/images/communication.png', route: 'users'),
    NavItem(label: 'Make a Request', iconPath: 'assets/images/request.png', route: 'requests'),
    NavItem(label: 'Profile', iconPath: 'assets/images/user.png', route: 'providers'),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication token not found. Please sign in again.')),
          );
          Navigator.pushReplacementNamed(context, '/signin');
        }
        return;
      }

      final user = await _authService.getProfile(token);
      setState(() {
        _requesterId = user.id;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: ${e.toString()}')),
        );
        Navigator.pushReplacementNamed(context, '/signin');
      }
    }
  }

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
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: const [],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFBABABA),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6572),
                    foregroundColor: Colors.white,
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
    if (_requesterId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_selectedIndex) {
      case 0:
        return const RecruitmentScreen();
      case 1:
        return const MyRequestsScreen();
      case 2:
        return RequestServiceScreen(requesterId: _requesterId!);
      case 3:
        return const ProfileScreen();
      default:
        return const RecruitmentScreen();
    }
  }
}