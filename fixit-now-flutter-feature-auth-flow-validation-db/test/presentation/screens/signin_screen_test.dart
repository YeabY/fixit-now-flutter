import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixit_now/presentation/screens/signin_screen.dart';
import 'package:fixit_now/core/services/auth_service.dart';
import 'package:fixit_now/core/services/token_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}
class MockTokenService extends Mock implements TokenService {}

void main() {
  late MockAuthService mockAuthService;
  late MockTokenService mockTokenService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockTokenService = MockTokenService();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: SignInScreen(),
      routes: {
        '/signup': (context) => Scaffold(body: Text('Sign Up Screen')),
        '/admin': (context) => Scaffold(body: Text('Admin Screen')),
        '/provider': (context) => Scaffold(body: Text('Provider Screen')),
        '/usernav': (context) => Scaffold(body: Text('User Navigation Screen')),
      },
    );
  }

  group('SignInScreen Widget Tests', () {
    testWidgets('renders all UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify app bar title
      expect(find.text('FixItNow'), findsOneWidget);

      // Verify welcome text
      expect(find.text('Welcome Back!'), findsOneWidget);

      // Verify input fields
      expect(find.widgetWithText(TextField, 'Enter username'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Enter password'), findsOneWidget);

      // Verify sign in button
      expect(find.text('Sign In'), findsOneWidget);

      // Verify sign up link
      expect(find.text("Don't have an account? Sign Up"), findsOneWidget);
    });

    testWidgets('shows error message when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap sign in button without entering any data
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Verify error message
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('navigates to signup screen when signup link is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap sign up link
      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.text('Sign Up Screen'), findsOneWidget);
    });

    testWidgets('password field is obscured', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find password field
      final passwordField = find.widgetWithText(TextField, 'Enter password');
      expect(passwordField, findsOneWidget);

      // Verify password is obscured
      final TextField passwordTextField = tester.widget(passwordField);
      expect(passwordTextField.obscureText, isTrue);
    });
  });
}