import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixit_now/presentation/screens/signup_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: const Scaffold(
        body: SignUpScreen(),
      ),
      routes: {
        '/signin': (context) => const Scaffold(body: Text('Sign In Screen')),
      },
    );
  }

  group('SignUpScreen Widget Tests', () {
    testWidgets('renders all UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('FixItNow'), findsOneWidget);
      expect(find.text('Enter username'), findsOneWidget);
      expect(find.text('Enter email'), findsOneWidget);
      expect(find.text('Enter phone number'), findsOneWidget);
      expect(find.text('Enter password'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
      expect(find.text('Select account type'), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
    });

    testWidgets('shows error when passwords do not match', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter text in all fields
      await tester.enterText(find.widgetWithText(TextField, 'Enter username'), 'user');
      await tester.enterText(find.widgetWithText(TextField, 'Enter email'), 'user@email.com');
      await tester.enterText(find.widgetWithText(TextField, 'Enter phone number'), '1234567890');
      await tester.enterText(find.widgetWithText(TextField, 'Enter password'), 'password1');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'password2');
      
      // Find and tap the create account button
      final createAccountButton = find.widgetWithText(ElevatedButton, 'Create account');
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      
      // Wait for the SnackBar to appear
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750)); // SnackBar animation duration
      
      // Find the SnackBar text
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('shows error when password is too short', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter text in all fields
      await tester.enterText(find.widgetWithText(TextField, 'Enter username'), 'user');
      await tester.enterText(find.widgetWithText(TextField, 'Enter email'), 'user@email.com');
      await tester.enterText(find.widgetWithText(TextField, 'Enter phone number'), '1234567890');
      await tester.enterText(find.widgetWithText(TextField, 'Enter password'), '123');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), '123');
      
      // Find and tap the create account button
      final createAccountButton = find.widgetWithText(ElevatedButton, 'Create account');
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      
      // Wait for the SnackBar to appear
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750)); // SnackBar animation duration
      
      // Find the SnackBar text
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('shows error when account type is not selected', (WidgetTester tester) async {
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter text in all fields
      await tester.enterText(find.widgetWithText(TextField, 'Enter username'), 'user');
      await tester.enterText(find.widgetWithText(TextField, 'Enter email'), 'user@email.com');
      await tester.enterText(find.widgetWithText(TextField, 'Enter phone number'), '1234567890');
      await tester.enterText(find.widgetWithText(TextField, 'Enter password'), 'password1');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'password1');
      
      // Find and tap the create account button
      final createAccountButton = find.widgetWithText(ElevatedButton, 'Create account');
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      
      // Wait for the SnackBar to appear
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750)); // SnackBar animation duration
      
      // Find the SnackBar text
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please select account type'), findsOneWidget);
    });

    testWidgets('shows service category dropdown when PROVIDER is selected', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Find and tap the account type dropdown
      final accountTypeDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(accountTypeDropdown);
      await tester.tap(accountTypeDropdown);
      await tester.pumpAndSettle();
      
      // Find and tap the PROVIDER option
      final providerOption = find.text('PROVIDER').last;
      await tester.ensureVisible(providerOption);
      await tester.tap(providerOption);
      await tester.pumpAndSettle();
      
      // Verify service category dropdown appears
      expect(find.text('Select service category'), findsOneWidget);
    });

    testWidgets('shows error when service category is not selected for PROVIDER', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter text in all fields
      await tester.enterText(find.widgetWithText(TextField, 'Enter username'), 'user');
      await tester.enterText(find.widgetWithText(TextField, 'Enter email'), 'user@email.com');
      await tester.enterText(find.widgetWithText(TextField, 'Enter phone number'), '1234567890');
      await tester.enterText(find.widgetWithText(TextField, 'Enter password'), 'password1');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'password1');
      
      // Select PROVIDER account type
      final accountTypeDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(accountTypeDropdown);
      await tester.tap(accountTypeDropdown);
      await tester.pumpAndSettle();
      
      final providerOption = find.text('PROVIDER').last;
      await tester.ensureVisible(providerOption);
      await tester.tap(providerOption);
      await tester.pumpAndSettle();
      
      // Find and tap the create account button
      final createAccountButton = find.widgetWithText(ElevatedButton, 'Create account');
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      
      // Wait for the SnackBar to appear
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750)); // SnackBar animation duration
      
      // Find the SnackBar text
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please select service category'), findsOneWidget);
    });

    testWidgets('shows error for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter text in all fields
      await tester.enterText(find.widgetWithText(TextField, 'Enter username'), 'user');
      await tester.enterText(find.widgetWithText(TextField, 'Enter email'), 'invalid-email');
      await tester.enterText(find.widgetWithText(TextField, 'Enter phone number'), '1234567890');
      await tester.enterText(find.widgetWithText(TextField, 'Enter password'), 'password1');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'password1');
      
      // Select REQUESTER account type
      final accountTypeDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(accountTypeDropdown);
      await tester.tap(accountTypeDropdown);
      await tester.pumpAndSettle();
      
      final requesterOption = find.text('REQUESTER').last;
      await tester.ensureVisible(requesterOption);
      await tester.tap(requesterOption);
      await tester.pumpAndSettle();
      
      // Find and tap the create account button
      final createAccountButton = find.widgetWithText(ElevatedButton, 'Create account');
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      
      // Wait for the SnackBar to appear
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750)); // SnackBar animation duration
      
      // Find the SnackBar text
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });
  });
} 