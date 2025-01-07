import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart'; // Import the generated mock class
import 'package:steamy/screens/create_account_screen.dart'; // Replace with actual file path

// Mock class for the HTTP client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;

  setUp(() {
    // Initialize the mock HTTP client
    mockHttpClient = MockHttpClient();
  });

  testWidgets('should handle successful account creation', (tester) async {
    // Mock the HTTP response for successful account creation
    when(mockHttpClient.post(
      Uri.parse('http://127.0.0.1:8000/register'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(jsonEncode({'id': 1}), 200));

    // Build the widget and inject the mock client
    await tester.pumpWidget(
      MaterialApp(
        home: CreateAccountScreen(httpClient: mockHttpClient), // Inject mockHttpClient here
      ),
    );

    // Fill in valid data
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com'); // Email
    await tester.enterText(find.byType(TextField).at(1), 'password'); // Password
    await tester.enterText(find.byType(TextField).at(2), 'password'); // Re-enter password

    // Tap on the Continue button
    await tester.tap(find.text('Continue ->'));
    await tester.pump();

    // Verify that the navigation happened (indicating success)
    expect(find.text('Create Account'), findsNothing); // Check if the screen changed

    // Optionally verify that the correct HTTP request was made
    verify(mockHttpClient.post(
      Uri.parse('http://127.0.0.1:8000/register'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).called(1); // Ensure the post was called once
  });
}
