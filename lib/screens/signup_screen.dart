import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db_helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? selectedUserType;
  String? selectedServiceType;

  final List<String> userTypes = ['Requester', 'Provider'];
  final List<String> services = ['Plumbing', 'Electrician', 'Gardening', 'Cleaning', 'Painting'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FixItNow',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset('assets/images/user_logo.jpg'),
              const SizedBox(height: 30),

              _buildTextField(usernameController, 'Enter username'),
              const SizedBox(height: 15),

              _buildTextField(emailController, 'Enter email', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),

              _buildTextField(phoneController, 'Enter phone number', keyboardType: TextInputType.phone),
              const SizedBox(height: 15),

              _buildTextField(passwordController, 'Enter password', obscureText: true),
              const SizedBox(height: 15),

              _buildTextField(confirmPasswordController, 'Confirm password', obscureText: true),
              const SizedBox(height: 15),

              _buildDropdown('Select account type', userTypes, selectedUserType, (value) {
                setState(() {
                  selectedUserType = value;
                  selectedServiceType = null;
                });
              }),

              const SizedBox(height: 15),

              if (selectedUserType == 'Provider')
                _buildDropdown('Select service category', services, selectedServiceType, (value) {
                  setState(() => selectedServiceType = value);
                }),

              const SizedBox(height: 30),
              _buildRoundedButton('Create account', Colors.lightGreen, _signUpOffline),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(textBaseline: TextBaseline.alphabetic),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.black87)),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRoundedButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _signUpOffline() async {
    final db = DBHelper();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;


// Validate fields
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password must be at least 8 characters")));
      return;
    }

    if (selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select account type")));
      return;
    }

    if (selectedUserType == 'Provider' && selectedServiceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select service category")));
      return;
    }

    if (!isValidEmail(emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

// Check for unique username
    final existingUser = await db.getUserByUsername(username);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username already exists")));
      return;
    }

    final user = {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'role': selectedUserType,
      'serviceType': selectedUserType == 'Provider' ? selectedServiceType : null,
    };

    try {
      await db.register(user);

      // Store login status and user info
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      await prefs.setString('username', username);
      await prefs.setString('role', selectedUserType!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account created successfully!")));

      // Navigate
      Navigator.pushReplacementNamed(context, selectedUserType == 'Requester' ? '/req' : '/prov');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to create account")));
    }
  }
}