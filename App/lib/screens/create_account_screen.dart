import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;

  // Text Controllers for capturing input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  // Location data
  double? locationLat;
  double? locationLon;

  @override
  void initState() {
    super.initState();
    _getLocation(); // Fetch location when the screen loads
  }

  // Fetch the user's location
  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied. Please allow access.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied. Please enable them in the app settings.',
          ),
        ),
      );
      return;
    }

    // Try to fetch the location
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        locationLat = position.latitude;
        locationLon = position.longitude;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location fetched successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 86, 55, 157),
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
              _buildTitle(),
              const SizedBox(height: 30),
              _buildLabel('Email'),
              _buildTextField('Enter your email', emailController, false),
              const SizedBox(height: 20),
              _buildLabel('Password'),
              _buildPasswordField(
                controller: passwordController,
                isVisible: isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildLabel('Re-Enter Password'),
              _buildPasswordField(
                controller: rePasswordController,
                isVisible: isRePasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    isRePasswordVisible = !isRePasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 50),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildTextField(String hintText, TextEditingController controller, bool isPassword) {
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return TextField(
      controller: controller,
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
          child: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final email = emailController.text.trim();
          final password = passwordController.text.trim();
          final rePassword = rePasswordController.text.trim();

          if (email.isEmpty || password.isEmpty || rePassword.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('All fields are required')),
            );
            return;
          }

          if (password != rePassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords do not match')),
            );
            return;
          }

          if (locationLat == null || locationLon == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to fetch location')),
            );
            return;
          }

          final data = {
            "email": email,
            "password": password,
            "location_lat": locationLat,
            "location_lon": locationLon,
          };

          try {
            final response = await http.post(
              Uri.parse('https://your-backend-url.com/register'),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(data),
            );

            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account created successfully')),
              );
              Navigator.pushNamed(
                context,
                '/createAccount2',
                arguments: {"email": email, "password": password},
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${response.body}')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error connecting to server')),
            );
          }
        },
        child: const Text('Create Account'),
      ),
    );
  }
}
