import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final ApiService apiService = ApiService();

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String? selectedInterest;
  String? selectedLookingFor;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService.ensureLoggedIn(context);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Fetch current user ID from SharedPreferences
      final userId = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('userId'));
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Fetch user profile from the backend
      final response = await apiService.getUserProfile(int.parse(userId));
      displayNameController.text = response['display_name'] ?? '';
      bioController.text = response['bio'] ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateProfile() async {
    final displayName = displayNameController.text.trim();
    final bio = bioController.text.trim();
    final interest = selectedInterest;
    final lookingFor = selectedLookingFor;

    if (displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display Name is required')),
      );
      return;
    }

    if (interest == null || lookingFor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please select your interests and what you are looking for')),
      );
      return;
    }

    try {
      final userId = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('userId'));
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final updatedData = await apiService.updateProfile(
        int.parse(userId),
        displayName: displayName,
        bio: bio,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 86, 55, 157),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Name Field
            _buildLabel('Display Name'),
            _buildTextField(
                'Enter your display name', displayNameController, false),
            const SizedBox(height: 20),

            // Bio Field
            _buildLabel('Bio'),
            _buildTextField(
                'One sentence description of yourself', bioController, false),
            const SizedBox(height: 20),

            // Interests Dropdown
            _buildLabel('Interests'),
            DropdownButtonFormField<String>(
              value: selectedInterest,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              items: ['Music', 'Movies', 'Sports', 'Reading'].map((interest) {
                return DropdownMenuItem(
                  value: interest,
                  child: Text(interest),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedInterest = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // I'm Looking For Dropdown
            _buildLabel("I'm looking for:"),
            DropdownButtonFormField<String>(
              value: selectedLookingFor,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              items: ['Friendship', 'Dating', 'Networking'].map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLookingFor = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Update Button
            Center(
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: const Color(0xFF972EF2),
                ),
                child: const Text(
                  'Update Profile',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            Center(
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
                    // Clear userId from SharedPreferences
                    await SharedPreferences.getInstance()
                        .then((prefs) => prefs.remove('userId'));
                        apiService.ensureLoggedIn(context);
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
        color: Colors.black,
      ),
    );
  }

  /// TextField Widget
  Widget _buildTextField(
      String hintText, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey,
        ),
      ),
    );
  }
}
