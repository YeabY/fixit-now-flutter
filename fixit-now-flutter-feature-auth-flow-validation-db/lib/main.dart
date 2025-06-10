import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide ChangeNotifierProvider;
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/screens/signin_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/requester/user_nav_graph.dart';
import 'presentation/provider/provider_nav_graph.dart';
import 'presentation/admin/admin_nav_graph.dart';
import 'presentation/admin/dashboard_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixIt Now',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/admin': (context) => const AdminNavGraph(),
        '/provider': (context) => const ProviderNavGraph(), 
        '/usernav': (context) => const UserNavGraph(),
      },
    );
  }
}
