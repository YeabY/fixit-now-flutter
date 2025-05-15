import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db_helper.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        title: const Text(
          'FixItNow',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 90),
              Image.asset('assets/images/user_logo.jpg', height: 100),
              const SizedBox(height: 30),
              _buildTextField(usernameController, 'Enter username'),
              const SizedBox(height: 20),
              _buildTextField(passwordController, 'Enter password', obscureText: true),
              const SizedBox(height: 30),
              _buildRoundedButton('Login', Colors.lightGreen, _signInOffline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
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

  Future<void> _signInOffline() async {
    final db = DBHelper();
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    final user = await db.getUserByUsername(username);

    if (user != null && user['password'] == password) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      await prefs.setString('username', user['username']);
      await prefs.setString('role', user['role']);

      final role = user['role'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged in successfully as $role")));

      Navigator.pushReplacementNamed(context, role == 'Requester' ? '/req' : '/prov');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid username or password")));
    }
  }
}