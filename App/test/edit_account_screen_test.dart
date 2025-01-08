import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Steamy/screens/edit_account_screen.dart';
import 'package:Steamy/services/api_service.dart';
import 'edit_account_screen_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late ApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: EditAccountScreen(),
    );
  }

  group('EditAccountScreen Tests', () {
    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays user data after loading',
        (WidgetTester tester) async {
      when(mockApiService.getUserProfile(1)).thenAnswer((_) async => {
            'display_name': 'Test User',
            'bio': 'Test Bio',
          });

      SharedPreferences.setMockInitialValues({
        'userId': '1',
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Rebuild after initState
    });

    testWidgets('shows error message when failing to load user data',
        (WidgetTester tester) async {
      when(mockApiService.getUserProfile(1))
          .thenThrow(Exception('Failed to load user data'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
    });

    testWidgets('updates profile successfully', (WidgetTester tester) async {
      when(mockApiService.updateProfile(1,
              displayName: anyNamed('displayName'), bio: anyNamed('bio')))
          .thenAnswer((_) async => {});

      SharedPreferences.setMockInitialValues({'userId': '1'});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Rebuild after initState

      await tester.enterText(find.byType(TextField).at(0), 'New Display Name');
      await tester.enterText(find.byType(TextField).at(1), 'New Bio');

      // Select interest
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Music').last);
      await tester.pumpAndSettle();

      // Select "I'm looking for"
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Friendship').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Rebuild after button press

      when(mockApiService.updateProfile(1,
          displayName: 'New Display Name', bio: 'New Bio'));
    });
  });
}
