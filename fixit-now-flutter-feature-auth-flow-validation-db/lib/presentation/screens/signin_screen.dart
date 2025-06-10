import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/token_service.dart';

class SignInScreen extends StatefulWidget {
const SignInScreen({super.key});

@override
State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final _authService = AuthService();
final _tokenService = TokenService();
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
const Text(
'Welcome Back!',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
),
const SizedBox(height: 30),
_buildTextField(usernameController, 'Enter username'),
const SizedBox(height: 20),
_buildTextField(passwordController, 'Enter password', obscureText: true),
const SizedBox(height: 30),
_buildRoundedButton('Sign In', Color(0xFF62CC39), _signIn),
const SizedBox(height: 20),
GestureDetector(
onTap: () {
Navigator.pushNamed(context, '/signup');
},
child: const Text(
"Don't have an account? Sign Up",
style: TextStyle(
color: Colors.blue,
decoration: TextDecoration.underline,
),
),
),
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
child: isLoading
? const CircularProgressIndicator()
    : Text(
text,
style: const TextStyle(color: Colors.black, fontSize: 16),
),
),
);
}

Future<void> _signIn() async {
final name = usernameController.text.trim();
final password = passwordController.text;

if (name.isEmpty || password.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Please fill in all fields")),
);
return;
}

setState(() => isLoading = true);

try {
final response = await _authService.login(name, password);
await _tokenService.saveToken(response['access_token']);

// Fetch user profile to get the role
final user = await _authService.getProfile(response['access_token']);
print('User profile: ${user.toJson()}');
final role = user.role.toString().split('.').last.toUpperCase();

if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Signed in successfully")),
);

// Clear the navigation stack and navigate to the appropriate screen
if (role == 'ADMIN') {
Navigator.pushNamedAndRemoveUntil(
context,
'/admin',
(route) => false,
);
} else if (role == 'PROVIDER') {
Navigator.pushNamedAndRemoveUntil(
context,
'/provider',
(route) => false,
);
} else if (role == 'REQUESTER') {
Navigator.pushNamedAndRemoveUntil(
context,
'/usernav',
(route) => false,
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Unknown user role")),
);
}
}
} catch (e) {
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text(e.toString())),
);
}
} finally {
if (mounted) {
setState(() => isLoading = false);
}
}
}

@override
void dispose() {
usernameController.dispose();
passwordController.dispose();
super.dispose();
}
}