import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_and_settings_provider.dart';

class ProfileAndSettingScreen extends ConsumerStatefulWidget {
  const ProfileAndSettingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileAndSettingScreen> createState() => _ProfileAndSettingScreenState();
}

class _ProfileAndSettingScreenState extends ConsumerState<ProfileAndSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _cbeAccountController = TextEditingController();
  final _awashAccountController = TextEditingController();
  final _paypalAccountController = TextEditingController();
  final _telebirrAccountController = TextEditingController();

  Map<String, bool> _editingFields = {};
  String _currentStatus = 'Idle'; // Local state for status

  @override
  void initState() {
    super.initState();
    ref.read(profileAndSettingsProvider.notifier).loadProfile();
  }

  void _initializeControllers(Map<String, dynamic> profile) {
    _nameController.text = profile['name'] ?? '';
    _emailController.text = profile['email'] ?? '';
    _phoneController.text = profile['phone'] ?? '';
    _genderController.text = profile['gender'] ?? '';
    _cbeAccountController.text = profile['cbeAccount'] ?? '';
    _awashAccountController.text = profile['awashAccount'] ?? '';
    _paypalAccountController.text = profile['paypalAccount'] ?? '';
    _telebirrAccountController.text = profile['telebirrAccount'] ?? '';
  }

  Future<void> _saveField(String fieldName, String value) async {
    final profileState = ref.read(profileAndSettingsProvider);
    if (profileState.hasValue) {
      final profile = profileState.value!;
      if (profile['id'] == null) {
        throw Exception('User ID not found');
      }

      await ref.read(profileAndSettingsProvider.notifier).updateProfile(
        userId: profile['id'],
        name: fieldName == 'name' ? value : _nameController.text,
        email: fieldName == 'email' ? value : _emailController.text,
        phone: fieldName == 'phone' ? value : _phoneController.text,
        gender: fieldName == 'gender' ? value : _genderController.text,
        serviceType: profile['serviceType'] ?? 'General',
        cbeAccount: fieldName == 'cbeAccount' ? value : _cbeAccountController.text,
        awashAccount: fieldName == 'awashAccount' ? value : _awashAccountController.text,
        paypalAccount: fieldName == 'paypalAccount' ? value : _paypalAccountController.text,
        telebirrAccount: fieldName == 'telebirrAccount' ? value : _telebirrAccountController.text,
      );

      setState(() {
        _editingFields[fieldName] = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _cbeAccountController.dispose();
    _awashAccountController.dispose();
    _paypalAccountController.dispose();
    _telebirrAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileAndSettingsProvider);

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
                onPressed: () => ref.read(profileAndSettingsProvider.notifier).loadProfile(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (profile) {
        _initializeControllers(profile);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Profile & Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoContainer(_buildPersonalInfoContent(profile)),
                  const SizedBox(height: 24),
                  const Text(
                    'Payment Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoContainer(_buildAccountsContent()),
                  const SizedBox(height: 24),
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusToggle(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _buildPersonalInfoContent(Map<String, dynamic> profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldRow('Name', _nameController, 'name', isRequired: true),
        _buildFieldRow('Email', _emailController, 'email', isRequired: true, isEmail: true),
        _buildFieldRow('Phone', _phoneController, 'phone', isRequired: true),
        _buildFieldRow('Gender', _genderController, 'gender'),
        _buildReadOnlyField('Role', profile['role'] ?? 'User'),
        _buildReadOnlyField('Service Type', profile['serviceType'] ?? 'General'),
      ],
    );
  }

  Widget _buildAccountsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldRow('CBE Account', _cbeAccountController, 'cbeAccount'),
        _buildFieldRow('Awash Account', _awashAccountController, 'awashAccount'),
        _buildFieldRow('PayPal Email', _paypalAccountController, 'paypalAccount'),
        _buildFieldRow('TeleBirr Phone', _telebirrAccountController, 'telebirrAccount'),
      ],
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller, String fieldName,
      {bool isRequired = false, bool isEmail = false}) {
    final isEditing = _editingFields[fieldName] ?? false;

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
                  ? TextFormField(
                      controller: controller,
                      decoration: const InputDecoration.collapsed(hintText: ''),
                      validator: (value) {
                        if (isRequired && (value == null || value.isEmpty)) {
                          return 'Required';
                        }
                        if (isEmail && value != null && !value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    )
                  : Text(controller.text.isEmpty ? 'Not set' : controller.text),
            ),
          ),
          IconButton(
            icon: isEditing ? const Icon(Icons.save) : const Text('✏️', style: TextStyle(fontSize: 18)),
            onPressed: () {
              setState(() {
                _editingFields[fieldName] = !(isEditing);
              });
              if (isEditing) {
                _saveField(fieldName, controller.text);
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
              child: Text(value),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatusToggle() {
    final statusOptions = ['Idle', 'Working', 'Do Not Disturb'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: statusOptions.map((status) {
          return CheckboxListTile(
            title: Text(
              status,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            value: _currentStatus == status,
            onChanged: (bool? selected) {
              if (selected == true) {
                setState(() {
                  _currentStatus = status;
                });
              }
            },
            activeColor: Colors.green,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }
}