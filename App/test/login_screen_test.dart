import 'package:Steamy/screens/login_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginSuccessScreen displays email correctly',
      (WidgetTester tester) async {
    const testEmail = 'test@example.com';

    await tester.pumpWidget(
      const MaterialApp(
        home: LoginSuccessScreen(email: testEmail),
      ),
    );

    expect(find.text('Login Successful'), findsOneWidget);
    expect(find.text('Welcome, $testEmail!'), findsOneWidget);
  });

  testWidgets('LoginSuccessScreen has AppBar with correct title',
      (WidgetTester tester) async {
    const testEmail = 'test@example.com';

    await tester.pumpWidget(
      const MaterialApp(
        home: LoginSuccessScreen(email: testEmail),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Login Successful'), findsOneWidget);
  });

  testWidgets('LoginSuccessScreen has centered text',
      (WidgetTester tester) async {
    const testEmail = 'test@example.com';

    await tester.pumpWidget(
      const MaterialApp(
        home: LoginSuccessScreen(email: testEmail),
      ),
    );

    final textFinder = find.text('Welcome, $testEmail!');
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
    expect(
        tester.getCenter(textFinder), equals(tester.getCenter(centerFinder)));
  });
}
