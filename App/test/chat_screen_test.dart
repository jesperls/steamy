import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:steamy/screens/chat_screen.dart';
import 'package:mockito/annotations.dart';

// Create a mock HTTP client
class MockClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
  });

  testWidgets('displays a message after user sends it',
      (WidgetTester tester) async {
    // Mock the POST request response to simulate success
    when(mockClient.post(
      Uri.parse('http://127.0.0.1:8000/sendMessage'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"status": "success"}', 200));

    // Build the widget with mock client
    await tester.pumpWidget(MaterialApp(
      home: ChatScreen(
        matchedUserName: 'John',
        matchedUserId: 1,
      ),
    ));

    // Enter a message in the text field
    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Check if the message appears in the chat
    expect(find.text('You: Hello'), findsOneWidget);
  });

  testWidgets('displays error message when sending fails',
      (WidgetTester tester) async {
    // Mock a failed POST request response
    when(mockClient.post(
      Uri.parse('http://127.0.0.1:8000/sendMessage'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"status": "error"}', 400));

    // Build the widget with mock client
    await tester.pumpWidget(MaterialApp(
      home: ChatScreen(
        matchedUserName: 'John',
        matchedUserId: 1,
      ),
    ));

    // Enter a message in the text field
    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Check if an error message is shown
    expect(
        find.text('Failed to send message: Exception: Failed to send message'),
        findsOneWidget);
  });
}
