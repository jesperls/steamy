import 'package:Steamy/screens/matching_screen.dart';
import 'package:Steamy/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'matching_screen_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: MatchPage(),
    );
  }

  group('MatchPage Tests', () {
    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ensure CircularProgressIndicator is displayed initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
