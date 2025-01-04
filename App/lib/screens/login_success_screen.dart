import 'package:flutter/material.dart';

class LoginSuccessScreen extends StatelessWidget {
  final String email;

  const LoginSuccessScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Successful'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Welcome, $email!',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
