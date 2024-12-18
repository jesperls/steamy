import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 86, 55, 157), // Purple background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 86, 55, 157),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Title
              _buildTitle(),
              const SizedBox(height: 30),

              // Email Field
              _buildLabel('Email'),
              _buildTextField('Enter your email', false),
              const SizedBox(height: 20),

              // Password Field
              _buildLabel('Password'),
              _buildPasswordField(
                isVisible: isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Re-Enter Password Field
              _buildLabel('Re-Enter Password'),
              _buildPasswordField(
                isVisible: isRePasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    isRePasswordVisible = !isRePasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 50),

              // Continue Button
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }


  /// Builds the Title Section
  Widget _buildTitle() {
    return const Center(
      child: Text(
        'Create Account',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the Label for Input Fields
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

  /// Builds a TextField for Input
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

  /// Builds a Password Field with Visibility Toggle
  Widget _buildPasswordField({
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return TextField(
      obscureText: !isVisible,
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
          onTap: onVisibilityToggle,
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

  /// Builds the Continue Button
  Widget _buildContinueButton(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = constraints.maxWidth * 0.6;

        return Center(
          child: Container(
            width: buttonWidth.clamp(200.0, 400.0),
            height: 50.0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE9E923),
                  Color(0xFFCAA470),
                  Color(0xFF972EF2),
                ],
                stops: [0.0, 0.37, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createAccount2');
              },
              child: const Text(
                'Continue ->',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
