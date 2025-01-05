import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:steamy/screens/onboarding_screen.dart';
import 'onboarding_screen_test.mocks.dart';


@GenerateMocks([NavigatorObserver])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      expect(find.byType(TextField), findsNWidgets(2)); // Email and password fields

      // Verify buttons and links
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Let's Steam!"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Locate the password visibility icon
      final visibilityIcon = find.byIcon(Icons.visibility_off);

      // Ensure the password is initially hidden
      expect(visibilityIcon, findsOneWidget);

      // Tap the visibility toggle icon
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Verify the password is now visible
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('shows validation error for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Tap the "Let's Steam!" button
      await tester.tap(find.text("Let's Steam!"));
      await tester.pump();

      // Verify the error message
      expect(find.text('Please enter both email and password'), findsOneWidget);
    });

    testWidgets('navigates to Create Account screen', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          navigatorObservers: [mockObserver],
          routes: {
            '/createAccount': (context) => const Scaffold(body: Text('Create Account Screen')),
          },
        ),
      );

      // Tap the "Create Account" button
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Verify navigation to Create Account screen
      expect(find.text('Create Account Screen'), findsOneWidget);
    });

    testWidgets('navigates to Message screen on successful login', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          navigatorObservers: [mockObserver],
          routes: {
            '/message-screen': (context) => const Scaffold(body: Text('Message Screen')),
          },
        ),
      );

      // Fill the email and password fields
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Tap the "Let's Steam!" button
      await tester.tap(find.text("Let's Steam!"));
      await tester.pumpAndSettle();

      // Verify navigation to the Message screen
      expect(find.text('Message Screen'), findsOneWidget);
    });

    testWidgets('shows error on failed login', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Fill the email and password fields
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'wrongpassword');

      // Tap the "Let's Steam!" button
      await tester.tap(find.text("Let's Steam!"));
      await tester.pump();

      // Verify error message is shown
      expect(find.text('Login failed'), findsOneWidget);
    });
  });
}
