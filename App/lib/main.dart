import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/message_screen.dart';

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
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFe88656),
          primary: const Color(0xFFe88656),
          secondary: const Color(0xFFec0a6c),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/', // Set the initial route to the home page
      routes: {
        '/': (context) => WelcomeScreen(), // Main starting screen
        '/messages': (context) => MessagePage(), // Navigation to MessagePage
      },
    );
  }
}
