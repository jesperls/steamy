import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:steamy/screens/onboarding_screen.dart';
import 'package:steamy/screens/create_account_screen.dart';
import 'package:steamy/screens/message_screen.dart';
import 'package:http/http.dart' as http;

// Generate mock for http.Client
@GenerateMocks([http.Client])
import 'onboarding_screen_test.mocks.dart';

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
      expect(find.byType(TextField), findsNWidgets(2)); // Email and password fields

      // Verify buttons and links
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Let's Steam!"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Locate the password TextField
      final passwordField = find.byType(TextField).last;

      // Verify the password is initially hidden
      expect(
        tester.widget<TextField>(passwordField).obscureText,
        isTrue,
      );

      // Locate the visibility toggle icon
      final visibilityIcon = find.byIcon(Icons.visibility_off);

      // Tap the visibility toggle icon to show the password
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Verify the password is now visible
      expect(
        tester.widget<TextField>(passwordField).obscureText,
        isFalse,
      );

      // Locate the visibility icon for visible state
      final visibilityOnIcon = find.byIcon(Icons.visibility);

      // Tap the visibility toggle icon to hide the password again
      await tester.tap(visibilityOnIcon);
      await tester.pump();

      // Verify the password is hidden again
      expect(
        tester.widget<TextField>(passwordField).obscureText,
        isTrue,
      );
    });

    testWidgets('shows validation error for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Locate the "Let's Steam!" button
      final steamButton = find.text("Let's Steam!");
      expect(steamButton, findsOneWidget);

      // Tap the button without entering text in email or password fields
      await tester.tap(steamButton);
      await tester.pump(); // Rebuild the widget to reflect UI changes

      // Verify the error message is displayed
      expect(find.text('Please enter both email and password'), findsOneWidget);
    });

    testWidgets('navigates to Create Account screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          routes: {
            '/createAccount': (context) => const CreateAccountScreen(),
          },
        ),
      );

      // Ensure "Create Account" button is visible
      final createAccountButton = find.text('Create Account');
      expect(createAccountButton, findsOneWidget);

      // Tap the "Create Account" button
      await tester.tap(createAccountButton);
      await tester.pumpAndSettle(); // Wait for the navigation animation to complete

      // Verify navigation to CreateAccountScreen
      expect(find.text('Create Account'), findsOneWidget); // Title in CreateAccountScreen
    });

    testWidgets('navigates to Message screen on successful login', (WidgetTester tester) async {
      // Mock the HTTP client
      final mockClient = MockClient();

      // Mock a successful login response
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:8000/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"success": true}', 200));

      // Mock the fetch matches response for MessagePage
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:8000/getMatches'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('[]', 200)); // Empty matches

      // Pump the widget with the mocked client
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          routes: {
            '/message-screen': (context) => const MessagePage(),
          },
        ),
      );

      // Fill in the email and password fields
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Tap the "Let's Steam!" button
      final steamButton = find.text("Let's Steam!");
      await tester.tap(steamButton);
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Verify navigation to the Message screen
      expect(find.byType(MessagePage), findsOneWidget);
    });
  });
}
