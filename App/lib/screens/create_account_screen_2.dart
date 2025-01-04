import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAccount2Screen extends StatefulWidget {
  final String userId;
  const CreateAccount2Screen({super.key, required this.userId});

  @override
  State<CreateAccount2Screen> createState() => _CreateAccount2ScreenState();
}

class _CreateAccount2ScreenState extends State<CreateAccount2Screen> {
  final TextEditingController nameController = TextEditingController();
  String? selectedInterest;
  String? selectedPreference;

  final String updateProfileEndpoint = "http://127.0.0.1:8000/updateProfile";

  final List<String> interests = ["Music", "Movies", "Sports", "Reading"];
  final List<String> preferences = ["Friendship", "Dating", "Networking"];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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
              _buildProfilePicture(screenWidth),
              const SizedBox(height: 20),
              _buildLabel('Name'),
              _buildTextField('Enter your name', nameController),
              const SizedBox(height: 20),
              _buildLabel('Interests'),
              _buildDropdown(interests, selectedInterest, (value) {
                setState(() {
                  selectedInterest = value;
                });
              }),
              const SizedBox(height: 20),
              _buildLabel("I'm looking for:"),
              _buildDropdown(preferences, selectedPreference, (value) {
                setState(() {
                  selectedPreference = value;
                });
              }),
              const SizedBox(height: 40),
              _buildJoinButton(context),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildDropdown(List<String> items, String? selectedValue, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
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
            // Ensure interest and preference are selected and name is not empty
            if (selectedInterest == null || selectedPreference == null || nameController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all fields before proceeding.')),
              );
              return;
            }

            // Prepare payload
            final payload = {
              'id': widget.userId,
              'display_name': nameController.text.trim(),
              'preferences': selectedPreference,
              'bio': selectedInterest,
            };

            // Print payload for debugging
            print("Payload to be sent: $payload");

            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );

            try {
              // Send update profile request
              final response = await http.put(
                Uri.parse(updateProfileEndpoint),
                headers: <String, String>{'Content-Type': 'application/json'},
                body: jsonEncode(payload),
              );

              Navigator.pop(context); // Close loading indicator

              // Print response for debugging
              print("Response status: ${response.statusCode}");
              print("Response body: ${response.body}");

              if (response.statusCode == 200) {
                // Success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile Updated Successfully!')),
                );
                Navigator.pushNamed(context, '/matchingScreen');
              } else {
                // Backend returned an error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${response.body}')),
                );
              }
            } catch (e) {
              Navigator.pop(context); // Close loading indicator
              // Log error for debugging
              print("Error occurred: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error connecting to server')),
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
