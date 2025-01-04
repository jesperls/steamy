import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isPasswordVisible = false; // Controls password visibility

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
              // Hearts Image at the top
              Center(
                child: Image.asset(
                  'assets/images/hearts.png',
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.2,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // Welcome Back Text
              _buildText('Welcome Back!', 35, const Color(0xFFE9E923),
                  FontWeight.bold, TextAlign.center),
              const SizedBox(height: 10),

              // Subtext
              _buildText(
                'Hi, Kindly login to start your love journey',
                12.5,
                Colors.white,
                FontWeight.normal,
                TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Email Field
              _buildLabel('Email'),
              _buildTextField('Enter your email', false),

              // Password Field
              const SizedBox(height: 20),
              _buildLabel('Password'),
              _buildPasswordField(),

              // Forgot Password
              const SizedBox(height: 10),
              _buildForgotPasswordLink(),

              // Let's Steam Button
              const SizedBox(height: 30),
              _buildSteamButton(),

              // Create Account Link
              const SizedBox(height: 20),
              _buildCreateAccountLink(),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper Method: Builds the Label Text
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

  /// Helper Method: Builds a Regular TextField
  Widget _buildTextField(String hintText, bool isPassword) {
    return TextField(
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

  /// Helper Method: Builds a Password Field with Toggle
  Widget _buildPasswordField() {
    return TextField(
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
          child: Image.asset(
            'assets/images/pass_eye.png',
            color: Colors.white54,
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }

  /// Forgot Password Link
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

  /// "Let's Steam!" Button
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
            onPressed: () {
              Navigator.pushNamed(context, '/message-room');
            },
            child: const Text(
              "Let's Steam !",
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

  /// Helper Method: Builds Text Widgets
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

  /// Helper Method: Builds the "Create Account" Section
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
