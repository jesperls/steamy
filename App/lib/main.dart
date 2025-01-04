import 'package:flutter/material.dart';
import 'screens/message_screen.dart' as message_screen;
import 'screens/create_account_screen.dart'
    as create_account; // Alias for create_account
import 'screens/create_account_screen_2.dart'
    as create_account2; // Alias for create_account2
import 'screens/matching_screen.dart'
    as matching_page; // Alias for matching_page
import 'screens/onboarding_screen.dart' as onboarding; // Alias for onboarding
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Steamy',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFe88656),
          primary: const Color(0xFFe88656),
          secondary: const Color(0xFFec0a6c),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/', // Default route
      routes: {
        '/': (context) => const WelcomeScreen(), // Home screen
        '/onboarding': (context) =>
            const onboarding.OnboardingScreen(), // Onboarding screen
        '/createAccount': (context) =>
            const create_account.CreateAccountScreen(), // Create Account
        '/createAccount2': (context) =>
            const create_account2.CreateAccount2Screen(), // Create Account 2
        '/matching_page': (context) =>
            const matching_page.MatchPage(), // Matching Page
        '/message-screen': (context) =>
            const message_screen.MessagePage(), //added
      },
    );
  }
}
