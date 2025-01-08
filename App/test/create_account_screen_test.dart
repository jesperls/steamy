import 'dart:convert';
import 'package:Steamy/screens/create_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Generate mock for http.Client
@GenerateMocks([http.Client])
import 'create_account_screen_test.mocks.dart';

void main() {
  group('CreateAccountScreen Tests', () {
    testWidgets('renders all UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateAccountScreen()));

      // Verify title
      expect(find.byType(IconButton), findsOneWidget);

      // Verify email input field
      expect(find.byType(TextField).at(0), findsOneWidget);

      // Verify password input field
      expect(find.byType(TextField).at(1), findsOneWidget);

      // Verify re-enter password input field
      expect(find.byType(TextField).at(2), findsOneWidget);
    });

    testWidgets('shows validation error for empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateAccountScreen()));

      // Tap the create account button without entering any data
      await tester.tap(find.text('Create Account').at(1));
      await tester.pump();

      // Verify the error message is displayed
      expect(find.text('All fields are required'), findsOneWidget);
    });

    testWidgets('shows validation error for mismatched passwords',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateAccountScreen()));

      // Enter email and passwords
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password456');

      // Tap the create account button
      await tester.tap(find.text('Create Account').at(1));
      await tester.pump();

      // Verify the error message is displayed
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('navigates to next screen on successful account creation',
        (WidgetTester tester) async {
      // Mock the HTTP client
      final mockClient = MockClient();

      // Mock a successful account creation response
      when(mockClient.post(
        Uri.parse('http://localhost:8000/createAccount'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"success": true}', 200));

      // Pump the widget with the mocked client
      await tester.pumpWidget(
        MaterialApp(
          home: const CreateAccountScreen(),
          routes: {
            '/createAccount2': (context) =>
                const Scaffold(body: Text('Next Screen')),
          },
        ),
      );

      // Enter email and passwords
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password123');

      // Tap the create account button
      await tester.tap(find.text('Create Account').at(1));
      await tester.pumpAndSettle(); // Wait for navigation to complete
    });
  });
}
