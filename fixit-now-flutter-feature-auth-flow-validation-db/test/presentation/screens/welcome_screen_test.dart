import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixit_now/presentation/screens/welcome_screen.dart';
import 'package:fixit_now/presentation/screens/signin_screen.dart';
import 'package:fixit_now/presentation/screens/signup_screen.dart';

void main() {
  group('WelcomeScreen Widget Tests', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: const Scaffold(
          body: WelcomeScreen(),
        ),
        routes: {
          '/signin': (context) => const Scaffold(body: SignInScreen()),
          '/signup': (context) => const Scaffold(body: SignUpScreen()),
        },
      );
    }

    testWidgets('renders UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify app bar
      expect(find.text('FixItNow'), findsOneWidget);

      // Verify logo
      expect(find.byType(Image), findsOneWidget);

      // Verify tagline
      expect(find.text('"Need a Pro? Get It Done in Minutes!"'), findsOneWidget);

      // Verify description text - using a more flexible finder
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && 
            widget.data?.contains('Say goodbye to endless searching') == true &&
            widget.data?.contains('Your to-do list just met its match!') == true,
        ),
        findsOneWidget,
      );

      // Verify buttons
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
    });

    testWidgets('navigates to SignInScreen when Sign In button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap the Sign In button
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.ensureVisible(signInButton);
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Verify navigation to SignInScreen
      expect(find.byType(SignInScreen), findsOneWidget);
    });

    testWidgets('navigates to SignUpScreen when Sign Up button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap the Sign Up button
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // Verify navigation to SignUpScreen
      expect(find.byType(SignUpScreen), findsOneWidget);
    });

    testWidgets('Sign In button has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the Sign In button
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      final button = tester.widget<ElevatedButton>(signInButton);

      // Verify button styling
      expect(button.style?.backgroundColor?.resolve({}), const Color(0xFF86D069));
      expect(button.style?.foregroundColor?.resolve({}), Colors.black);
    });

    testWidgets('Sign Up button has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the Sign Up button
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      final button = tester.widget<ElevatedButton>(signUpButton);

      // Verify button styling
      expect(button.style?.backgroundColor?.resolve({}), const Color(0xFF7EBADF));
      expect(button.style?.foregroundColor?.resolve({}), Colors.black);
    });
  });
} 