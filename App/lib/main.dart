import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/create_account_screen_2.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/': (context) => const WelcomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/createAccount': (context) => const CreateAccountScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/createAccount2') {
          final args = settings.arguments as Map<String, dynamic>;
          if (args.containsKey('userId')) {
            return MaterialPageRoute(
              builder: (context) => CreateAccount2Screen(userId: args['userId']),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Error: Missing userId')),
              ),
            );
          }
        }
        return null;
      },
    );
  }
}
