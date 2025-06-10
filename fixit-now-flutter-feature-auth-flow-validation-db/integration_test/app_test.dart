import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fixit_now/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Complete authentication flow test', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify we're on the welcome screen
      expect(find.text('FixItNow'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      // Test Sign Up flow
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Fill in sign up form
      final usernameField = find.widgetWithText(TextField, 'Enter username');
      final emailField = find.widgetWithText(TextField, 'Enter email');
      final phoneField = find.widgetWithText(TextField, 'Enter phone number');
      final passwordField = find.widgetWithText(TextField, 'Enter password');
      final confirmPasswordField = find.widgetWithText(TextField, 'Confirm password');

      await tester.ensureVisible(usernameField);
      await tester.enterText(usernameField, 'testuser1');
      await tester.pump();

      await tester.ensureVisible(emailField);
      await tester.enterText(emailField, 'test@example1.com');
      await tester.pump();

      await tester.ensureVisible(phoneField);
      await tester.enterText(phoneField, '1234567890');
      await tester.pump();

      await tester.ensureVisible(passwordField);
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      await tester.ensureVisible(confirmPasswordField);
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.pump();

      // Select account type
      final accountTypeDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(accountTypeDropdown);
      await tester.tap(accountTypeDropdown);
      await tester.pumpAndSettle();

      final requesterOption = find.text('REQUESTER').last;
      await tester.ensureVisible(requesterOption);
      await tester.tap(requesterOption);
      await tester.pumpAndSettle();

      // Submit sign up form
      final createAccountButton = find.widgetWithText(ElevatedButton, 'Create account');
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify success message and navigation to sign in
      expect(find.text('Account created successfully!'), findsOneWidget);
      
      // Wait for the success message SnackBar to disappear
      await tester.pumpAndSettle(const Duration(seconds: 4));
      
      // Test Sign In flow
      // First verify we're on the sign in screen
      expect(find.text('Sign In'), findsOneWidget);
      await tester.pumpAndSettle();

      // Debug prints to see what's available
      debugPrint('Available TextFields: ${tester.widgetList(find.byType(TextField)).length}');
      debugPrint('Available Text widgets: ${tester.widgetList(find.byType(Text)).length}');
      debugPrint('Available InputDecorations: ${tester.widgetList(find.byType(InputDecoration)).length}');
      
      // Print all TextField decorations to see what labels are available
      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      for (var field in textFields) {
        if (field.decoration is InputDecoration) {
          debugPrint('TextField label: ${(field.decoration as InputDecoration).labelText}');
        }
      }

      // Try to find the email field by index since we know there are only 2 fields
      final textFieldsList = tester.widgetList<TextField>(find.byType(TextField)).toList();
      if (textFieldsList.length >= 2) {
        // First field should be email
        await tester.enterText(find.byType(TextField).first, 'test@example1.com');
        await tester.pump();
        
        // Second field should be password
        await tester.enterText(find.byType(TextField).last, 'password123');
        await tester.pump();
      } else {
        fail('Expected at least 2 text fields for sign in, but found ${textFieldsList.length}');
      }

      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      
      // Wait for the error message to appear and SnackBar animation to complete
      await tester.pump();
      await tester.pump(const Duration(seconds: 2)); // Wait longer for the error message
      
      // Debug print to see what text widgets are available after error
      debugPrint('Text widgets after error:');
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (var text in textWidgets) {
        debugPrint('Text widget: ${text.data}');
      }
      
      // Debug print to see what SnackBars are available
      debugPrint('SnackBars after error:');
      final snackBars = tester.widgetList<SnackBar>(find.byType(SnackBar));
      for (var snackBar in snackBars) {
        debugPrint('SnackBar content: ${snackBar.content}');
      }
      
      // Look for error message in SnackBar
      final snackBar = find.byType(SnackBar);
      if (tester.widgetList(snackBar).isNotEmpty) {
        // Look for any text containing "credentials" or "unauthorized"
        expect(find.textContaining('credentials'), findsOneWidget);
      } else {
        // If no SnackBar, look for error message in any Text widget
        expect(find.textContaining('credentials'), findsOneWidget);
      }
      
      // Verify we're still on the sign in screen
      expect(find.text('Sign In'), findsOneWidget);
    });
  });
} 