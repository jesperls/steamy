import 'package:flutter/material.dart';

class CreateAccount2Screen extends StatelessWidget {
  const CreateAccount2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              _buildTextField('Enter your name'),

              const SizedBox(height: 20),

              // Interests Dropdown
              _buildLabel('Interests'),
              _buildDropdown(['Music', 'Movies', 'Sports', 'Reading']),

              const SizedBox(height: 20),

              // Looking For Dropdown
              _buildLabel("I'm looking for:"),
              _buildDropdown(['Friendship', 'Dating', 'Networking']),

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
  Widget _buildTextField(String hintText) {
    return TextField(
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
  Widget _buildDropdown(List<String> items) {
    String? selectedValue;

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
      onChanged: (value) {
        selectedValue = value;
      },
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
          onPressed: () {
            // Add navigation logic here
            Navigator.popUntil(context, ModalRoute.withName('/'));
            //add path to matching page
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
