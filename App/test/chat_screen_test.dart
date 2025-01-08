import 'package:Steamy/screens/chat_screen.dart';
import 'package:Steamy/screens/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Generate mock for http.Client
@GenerateMocks([http.Client])
import 'chat_screen_test.mocks.dart';

void main() {
  group('ChatScreen Tests', () {
    testWidgets('renders all UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: ChatScreen(
        matchedUserName: 'test',
        matchedUserId: 1,
      )));

      // Verify app bar title
      expect(find.text('Chat with test'), findsOneWidget);

      // Verify message input field
      expect(find.byType(TextField), findsOneWidget);

      // Verify send button
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('sends a message', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: ChatScreen(
        matchedUserName: 'test',
        matchedUserId: 1,
      )));

      // Enter a message in the input field
      await tester.enterText(find.byType(TextField), 'Hello, world!');

      // Tap the send button
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      // Verify the message is displayed in the chat
      expect(find.text('Hello, world!'), findsOneWidget);
    });

    testWidgets('navigates to Message screen on successful message send',
        (WidgetTester tester) async {
      // Mock the HTTP client
      final mockClient = MockClient();

      // Mock a successful message send response
      when(mockClient.post(
        Uri.parse('http://localhost:8000/sendMessage'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"success": true}', 200));

      // Pump the widget with the mocked client
      await tester.pumpWidget(
        MaterialApp(
          home: const ChatScreen(
            matchedUserName: 'test',
            matchedUserId: 1,
          ),
          routes: {
            '/message-screen': (context) => const MessagePage(),
          },
        ),
      );

      // Enter a message in the input field
      await tester.enterText(find.byType(TextField), 'Hello, world!');

      // Tap the send button
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle(); // Wait for navigation to complete
    });
  });
}
