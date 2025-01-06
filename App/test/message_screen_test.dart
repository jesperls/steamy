import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:steamy/screens/chat_screen.dart';
import 'package:steamy/screens/message_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Mock HTTP Client
class MockClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  group('MessagePage Tests', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const MessagePage()));

      // Verify loading indicator is displayed before data is fetched
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays matches after successful fetch',
        (WidgetTester tester) async {
      // Mock successful response from the API
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:8000/getMatches'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(
          '[{"id": "1", "user_id_1": "1", "user_id_2": "2", "is_matched": "true", "created_at": "2025-01-01", "updated_at": "2025-01-01", "name": "John", "image": "image_url"}]',
          200,
        ),
      );

      await tester.pumpWidget(MaterialApp(home: const MessagePage()));

      // Trigger the _fetchMatches function
      await tester.pumpAndSettle();

      // Verify loading indicator is no longer visible
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Verify that the match is displayed
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('displays error message if API call fails',
        (WidgetTester tester) async {
      // Mock failed response from the API
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:8000/getMatches'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      await tester.pumpWidget(MaterialApp(home: const MessagePage()));

      // Trigger the _fetchMatches function
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Error loading matches: Exception: HTTP Error: 404'),
          findsOneWidget);
    });

    testWidgets('performs search and filters matches',
        (WidgetTester tester) async {
      // Mock a successful response with multiple matches
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:8000/getMatches'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(
          '[{"id": "1", "user_id_1": "1", "user_id_2": "2", "is_matched": "true", "created_at": "2025-01-01", "updated_at": "2025-01-01", "name": "John", "image": "image_url"}, {"id": "2", "user_id_1": "1", "user_id_2": "3", "is_matched": "true", "created_at": "2025-01-01", "updated_at": "2025-01-01", "name": "Jane", "image": "image_url"}]',
          200,
        ),
      );

      await tester.pumpWidget(MaterialApp(home: const MessagePage()));

      // Verify that both John and Jane appear in the list
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Jane'), findsOneWidget);

      // Perform search for "John"
      await tester.enterText(find.byType(TextField), 'John');
      await tester.pump();

      // Verify that only "John" is shown after filtering
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Jane'), findsNothing);
    });

    testWidgets('navigates to ChatScreen when a match is tapped',
        (WidgetTester tester) async {
      // Mock successful response with one match
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:8000/getMatches'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(
          '[{"id": "1", "user_id_1": "1", "user_id_2": "2", "is_matched": "true", "created_at": "2025-01-01", "updated_at": "2025-01-01", "name": "John", "image": "image_url"}]',
          200,
        ),
      );

      await tester.pumpWidget(MaterialApp(home: const MessagePage()));

      // Wait for the matches to load
      await tester.pumpAndSettle();

      // Tap on the match to navigate to ChatScreen
      await tester.tap(find.text('John'));
      await tester.pumpAndSettle();

      // Verify that the ChatScreen is displayed
      expect(find.byType(ChatScreen), findsOneWidget);
    });
  });
}
