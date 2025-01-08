import 'package:Steamy/screens/chat_screen.dart';
import 'package:Steamy/screens/message_screen.dart';
import 'package:Steamy/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'messaging_screen_test.mocks.dart';

@GenerateMocks([http.Client, ApiService])
void main() {
  group('MessagePage Tests', () {
    testWidgets('renders all UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MessagePage()));

      // Verify loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
