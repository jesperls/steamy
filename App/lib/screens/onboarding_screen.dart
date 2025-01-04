import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:steamy/screens/message_screen.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false; // Controls password visibility
  final String loginEndpoint = "http://127.0.0.1:8000/login";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 86, 55, 157),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 86, 55, 157),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/hearts.png',
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.2,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              _buildText(
                'Welcome Back!',
                35,
                const Color(0xFFE9E923),
                FontWeight.bold,
                TextAlign.center,
              ),
              const SizedBox(height: 10),
              _buildText(
                'Hi, Kindly login to start your love journey',
                12.5,
                Colors.white,
                FontWeight.normal,
                TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildLabel('Email'),
              _buildTextField('Enter your email', emailController, false),
              const SizedBox(height: 20),
              _buildLabel('Password'),
              _buildPasswordField(),
              const SizedBox(height: 10),
              _buildForgotPasswordLink(),
              const SizedBox(height: 30),
              _buildSteamButton(),
              const SizedBox(height: 20),
              _buildCreateAccountLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField(
      String hintText, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: 'Enter your password',
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white54,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          child: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Forgot password functionality
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _buildSteamButton() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE9E923),
                Color(0xFFCAA470),
                Color(0xFF972EF2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextButton(
            onPressed: () async {
              final String email = emailController.text.trim();
              final String password = passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter both email and password.')),
                );
                return;
              }

              try {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );

                // Send login request
                final response = await http.post(
                  Uri.parse(loginEndpoint),
                  headers: <String, String>{'Content-Type': 'application/json'},
                  body: jsonEncode(<String, String>{
                    'email': email,
                    'password': password,
                  }),
                );

                Navigator.pop(context); // Close loading indicator

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login Successful!')),
                  );

                  // Navigate to MessagePage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MessagePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: ${response.body}')),
                  );
                }
              } catch (e) {
                Navigator.pop(context); // Close loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error connecting to server.')),
                );
              }
            },

            child: const Text(
              "Let's Steam!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text, double fontSize, Color color,
      FontWeight fontWeight, TextAlign align) {
    return Center(
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  Widget _buildCreateAccountLink() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createAccount');
            },
            child: const Text(
              'Create Account',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFFE9E923),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
