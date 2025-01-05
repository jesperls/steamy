import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:steamy/screens/welcome_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WelcomeScreen Tests', () {
    testWidgets('renders title, tagline, and buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const WelcomeScreen(),
        ),
      );

      // Verify the title "Steamy" is displayed
      expect(find.text('Steamy'), findsOneWidget);

      // Verify the tagline text "Find Your" is displayed
      expect(find.text('Find Your'), findsOneWidget);

      // Verify the "Perfect PARTNER" text in RichText
      expect(
        find.byWidgetPredicate(
              (widget) =>
          widget is RichText &&
              widget.text.toPlainText() == 'Perfect PARTNER',
        ),
        findsOneWidget,
      );

      // Verify the "Get Started" button is displayed
      expect(find.text('Get Started'), findsOneWidget);

      // Verify the footer sticker (or any images) is present
      expect(find.byType(Image), findsWidgets); // Should find multiple images
    });

    testWidgets('navigates to onboarding screen when "Get Started" is pressed', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: const WelcomeScreen(),
          navigatorObservers: [mockObserver],
          routes: {
            '/onboarding': (context) => const Scaffold(body: Center(child: Text('Onboarding Screen'))),
          },
        ),
      );

      // Tap the "Get Started" button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Verify navigation to the onboarding screen
      expect(find.text('Onboarding Screen'), findsOneWidget);
    });
  });
}

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}
