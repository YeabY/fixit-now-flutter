import 'package:fix_it_now/screens/signin_screen.dart';
import 'package:fix_it_now/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
      body: SingleChildScrollView( // In case of overflow on small screens
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Top padding
            Center(
              child: Image.asset(
                'assets/images/fix_it_now_logo.png',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Need a Pro? Get It Done in Minutes!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,

            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Say goodbye to endless searching—our platform connects you with trusted, top-rated service providers instantly! Whether it’s plumbing, Painting, or home repairs, just browse, request, and relax. Track progress in real-time, pay securely, and enjoy hassle-free help. Your to-do list just met its match!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  ),
                  child: const Text('Sign In'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,

                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  ),
                  child: const Text('Sign Up'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
