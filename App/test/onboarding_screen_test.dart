import 'package:Steamy/screens/create_account_screen.dart';
import 'package:Steamy/screens/message_screen.dart';
import 'package:Steamy/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:steamy/screens/onboarding_screen.dart';
// import 'package:steamy/screens/create_account_screen.dart';
// import 'package:steamy/screens/message_screen.dart';

void main() {
  group('OnboardingScreen Tests', () {
    testWidgets('renders all UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Verify hearts image
      expect(find.byType(Image), findsOneWidget);

      // Verify texts
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(
        find.text('Hi, Kindly login to start your love journey'),
        findsOneWidget,
      );

      // Verify input fields
      expect(find.byType(TextField),
          findsNWidgets(2)); // Email and password fields

      // Verify buttons and links
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Let's Steam!"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      final passwordField = find.byType(TextField).last;

      expect(
        tester.widget<TextField>(passwordField).obscureText,
        isTrue,
      );

      final visibilityIcon = find.byIcon(Icons.visibility_off);

      await tester.tap(visibilityIcon);
      await tester.pump();

      expect(
        tester.widget<TextField>(passwordField).obscureText,
        isFalse,
      );

      final visibilityOnIcon = find.byIcon(Icons.visibility);

      await tester.tap(visibilityOnIcon);
      await tester.pump();

      expect(
        tester.widget<TextField>(passwordField).obscureText,
        isTrue,
      );
    });

    testWidgets('shows validation error for empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      final steamButton = find.text("Let's Steam!");
      expect(steamButton, findsOneWidget);

      await tester.tap(steamButton);
      await tester.pump();

      expect(find.text('Please enter both email and password'), findsOneWidget);
    });
  });
}
