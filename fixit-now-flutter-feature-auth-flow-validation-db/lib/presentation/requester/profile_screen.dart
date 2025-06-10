import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../../core/models/request.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, bool> _editingFields = {};
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _cbeController = TextEditingController();
  final _paypalController = TextEditingController();
  final _telebirrController = TextEditingController();
  final _awashController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(profileNotifierProvider.notifier).refreshProfile();
  }

  void _initializeControllers(Map<String, dynamic> profile) {
    _nameController.text = profile['name'] ?? '';
    _emailController.text = profile['email'] ?? '';
    _phoneController.text = profile['phone'] ?? '';
    _genderController.text = profile['gender'] ?? '';
    _cbeController.text = profile['cbeAccount'] ?? '';
    _paypalController.text = profile['paypalAccount'] ?? '';
    _telebirrController.text = profile['telebirrAccount'] ?? '';
    _awashController.text = profile['awashAccount'] ?? '';
  }

  Future<void> _saveField(String fieldName, String value) async {
    final profileState = ref.read(profileNotifierProvider);
    if (profileState.hasValue) {
      final profile = profileState.value!['profile'];
      if (profile == null || profile['id'] == null) {
        throw Exception('User ID not found');
      }

      await ref.read(profileNotifierProvider.notifier).updateProfile(
        userId: int.parse(profile['id'].toString()),
        name: fieldName == 'name' ? value : _nameController.text,
        email: fieldName == 'email' ? value : _emailController.text,
        phone: fieldName == 'phone' ? value : _phoneController.text,
        gender: fieldName == 'gender' ? value : _genderController.text,
        cbeAccount: fieldName == 'cbeAccount' ? value : _cbeController.text,
        paypalAccount: fieldName == 'paypalAccount' ? value : _paypalController.text,
        telebirrAccount: fieldName == 'telebirrAccount' ? value : _telebirrController.text,
        awashAccount: fieldName == 'awashAccount' ? value : _awashController.text,
      );

      setState(() {
        _editingFields[fieldName] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return profileState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(profileNotifierProvider.notifier).refreshProfile(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (data) {
        final profile = data['profile'];
        final recentRequests = data['recentRequests'] as List<Request>;
        _initializeControllers(profile);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,  
            titleSpacing: 16,
            title: const Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0, 
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle('Personal Information'),
                _buildPersonalInfoSection(profile),
                const SizedBox(height: 24),
                sectionTitle('Recent Requests'),
                _buildHistorySection(recentRequests),
                const SizedBox(height: 24),
                sectionTitle('Payment Accounts'),
                _buildAccountsSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(Map<String, dynamic> profile) {
    return Container(
      color: const Color(0xFFEAEAEA),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildFieldRow('Name', _nameController, 'name'),
          _buildFieldRow('Email', _emailController, 'email'),
          _buildFieldRow('Phone', _phoneController, 'phone'),
          _buildFieldRow('Gender', _genderController, 'gender'),
          _buildReadOnlyField('Role', profile['role'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildHistorySection(List<Request> requests) {
    return Container(
      color: const Color(0xFFEAEAEA),
      padding: const EdgeInsets.all(16.0),
      child: requests.isEmpty
          ? const Text('No recent requests')
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTableHeader(),
                  Column(
                    children: requests.map((request) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _tableCell(_formatDate(request.createdAt.toString()), flex: 2),
                            _tableCell(request.serviceType, flex: 3),
                            _tableCell(
                              request.status,
                              flex: 2,
                              style: TextStyle(
                                color: _getStatusColor(request.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _tableCell(request.providerName ?? 'Not assigned', flex: 3),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _HeaderCell(text: 'Date', flex: 2),
          _HeaderCell(text: 'Task', flex: 3),
          _HeaderCell(text: 'Status', flex: 2),
          _HeaderCell(text: 'Assigned Provider', flex: 3),
        ],
      ),
    );
  }

  Widget _tableCell(String text, {int flex = 1, TextStyle? style}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 100,
      child: Text(text, style: style ?? const TextStyle(fontSize: 14)),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildAccountsSection() {
    return Container(
      color: const Color(0xFFEAEAEA),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildFieldRow('CBE Account', _cbeController, 'cbeAccount'),
          _buildFieldRow('PayPal Account', _paypalController, 'paypalAccount'),
          _buildFieldRow('TeleBirr Account', _telebirrController, 'telebirrAccount'),
          _buildFieldRow('Awash Account', _awashController, 'awashAccount'),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller, String fieldName) {
    bool isEditing = _editingFields[fieldName] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD5D5D5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isEditing
                  ? TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  : Text(
                      controller.text.isEmpty ? 'Not set' : controller.text,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
          IconButton(
            icon: isEditing
                ? const Icon(Icons.save)
                : const Text('✏️', style: TextStyle(fontSize: 20)),
            onPressed: () {
              if (isEditing) {
                _saveField(fieldName, controller.text);
              } else {
                setState(() {
                  _editingFields[fieldName] = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD5D5D5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(value, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'ACCEPTED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _cbeController.dispose();
    _paypalController.dispose();
    _telebirrController.dispose();
    _awashController.dispose();
    super.dispose();
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell({Key? key, required this.text, this.flex = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
