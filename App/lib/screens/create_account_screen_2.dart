import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class CreateAccount2Screen extends StatefulWidget {
  const CreateAccount2Screen({super.key});

  @override
  State<CreateAccount2Screen> createState() => _CreateAccount2ScreenState();
}

class _CreateAccount2ScreenState extends State<CreateAccount2Screen> {
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final ApiService apiService = ApiService();
  String? selectedInterest;
  String? selectedLookingFor;
  
  late String email;
  late String password;
  late double locationLat;
  late double locationLon;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    email = args['email'];
    password = args['password'];
    locationLat = args['locationLat'];
    locationLon = args['locationLon'];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

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
              // Profile Picture
              _buildProfilePicture(screenWidth),

              const SizedBox(height: 20),

              // Name Input
              _buildLabel('Name'),
              _buildTextField('Enter your name', nameController),

              const SizedBox(height: 20),

              // Bio Input
              _buildLabel('Bio'),
              _buildTextField('One sentence description of yourself', bioController),

              const SizedBox(height: 20),

              // Interests Dropdown
              _buildLabel('Interests'),
              _buildDropdown(
                items: ['Music', 'Movies', 'Sports', 'Reading'],
                onChanged: (value) {
                  setState(() {
                    selectedInterest = value;
                  });
                },
                value: selectedInterest,
              ),

              const SizedBox(height: 20),

              // Looking For Dropdown
              _buildLabel("I'm looking for:"),
              _buildDropdown(
                items: ['Friendship', 'Dating', 'Networking'],
                onChanged: (value) {
                  setState(() {
                    selectedLookingFor = value;
                  });
                },
                value: selectedLookingFor,
              ),

              const SizedBox(height: 40),

              // Join Button
              _buildJoinButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Profile Picture Widget
  Widget _buildProfilePicture(double screenWidth) {
    return Center(
      child: Container(
        width: screenWidth * 0.3,
        height: screenWidth * 0.3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: const DecorationImage(
            image: AssetImage('assets/images/ariana_grande.png'),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.yellow, width: 2.0),
        ),
      ),
    );
  }

  /// Label Widget
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  /// TextField Widget
  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
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

  /// Dropdown Widget
  Widget _buildDropdown({
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String? value,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color.fromARGB(255, 86, 55, 157),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        color: Colors.white,
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  /// Join Button
  Widget _buildJoinButton(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 50,
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
          onPressed: () async {
            final name = nameController.text.trim();
            final bio = bioController.text.trim();
            final interest = selectedInterest;
            final lookingFor = selectedLookingFor;

            if (name.isEmpty || bio.isEmpty || interest == null || lookingFor == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All fields are required')),
              );
              return;
            }

            try {
              final userData = await apiService.registerUser(
                email,
                password,
                name,
                bio: bio,
                preferences: lookingFor,
                locationLat: locationLat,
                locationLon: locationLon,
              );
              Navigator.pushReplacementNamed(
                context,
                '/matching_page',
                arguments: userData,
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration failed: $e')),
              );
            }
          },
          child: const Text(
            'Join Steamy',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}