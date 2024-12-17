import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/message_screen.dart';
import 'screens/chat_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/messages': (context) => const MessagePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) => ChatScreen(
                matchedUserName: args['matchedUserName'],
                matchedUserId: args['matchedUserId'],
              ),
            );
          }
        }
        return null; // Fallback for invalid routes
      },
    );
  }
}
