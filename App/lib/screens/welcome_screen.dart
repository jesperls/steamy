import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth, // Full width of the screen
        height: screenHeight, // Full height of the screen
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 86, 55, 157), // Background color (purple)
        ),
        child: Stack(
          alignment: Alignment.center, // Aligns all children to the center
          children: [
            // Top Left Heart
            _buildHeart(
              'assets/images/heart1.png',
              screenWidth * 0.05, // Left position
              screenHeight * 0.05, // Top position
              screenWidth * 0.12, // Responsive width
              screenHeight * 0.06, // Responsive height
            ),

            // Top Right Heart
            _buildHeart(
              'assets/images/heart5.png',
              screenWidth * 0.05,
              screenHeight * 0.05,
              screenWidth * 0.12,
              screenHeight * 0.06,
              isRight: true, // Align to the right side
            ),

            // Heart Left of "Perfect" text
            _buildHeart(
              'assets/images/heart3.png',
              screenWidth * 0.1,
              screenHeight * 0.42,
              screenWidth * 0.1,
              screenHeight * 0.05,
            ),

            // Heart Right of "PARTNER" text
            _buildHeart(
              'assets/images/heart4.png',
              screenWidth * 0.1,
              screenHeight * 0.42,
              screenWidth * 0.1,
              screenHeight * 0.05,
              isRight: true,
            ),

            // Bottom Left Heart
            _buildHeart(
              'assets/images/heart5.png',
              screenWidth * 0.05,
              screenHeight * 0.15,
              screenWidth * 0.12,
              screenHeight * 0.06,
            ),

            // Bottom Center Heart
            _buildHeart(
              'assets/images/heart6.png',
              0,
              screenHeight * 0.15,
              screenWidth * 0.15,
              screenHeight * 0.08,
              isCenter: true, // Center the heart horizontally
            ),

            // Footer stickers at the bottom of the screen
            _buildFooterSticker('assets/images/footer_sticker.png', screenWidth),

            // Centered Title, Tagline, and Button
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Vertically center
              children: [
                _buildTitle(), // "Steamy" Title
                const SizedBox(height: 20), // Spacing
                _buildTagline(), // "Find Your Perfect PARTNER" text
                const SizedBox(height: 40), // Spacing
                _buildButton(screenWidth, screenHeight), // "Get Started" Button
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build hearts with positioning options
  Widget _buildHeart(
    String asset,
    double left,
    double top,
    double width,
    double height, {
    bool isRight = false, // Whether to position on the right side
    bool isCenter = false, // Whether to center the heart
  }) {
    return Positioned(
      top: top,
      left: isCenter ? null : (isRight ? null : left), // Align left or center
      right: isRight ? left : null, // Align right if needed
      child: Image.asset(
        asset, // Path to the heart image
        width: width, // Responsive width
        height: height, // Responsive height
      ),
    );
  }

  /// Helper method to build footer sticker image at the bottom
  Widget _buildFooterSticker(String asset, double width) {
    return Positioned(
      bottom: 0,
      child: Image.asset(
        asset, // Path to the footer image
        width: width, // Full screen width
        fit: BoxFit.cover, // Fit horizontally
      ),
    );
  }

  /// Helper method to build the "Steamy" title text
  Widget _buildTitle() {
    return const Text(
      'Steamy',
      style: TextStyle(
        fontFamily: 'CherryBombOne', // Custom font
        fontSize: 95, // Font size
        color: Colors.white, // White color
        fontWeight: FontWeight.w400, // Normal weight
      ),
    );
  }

  /// Helper method to build the tagline "Find Your Perfect PARTNER"
  Widget _buildTagline() {
    return Column(
      children: [
        const Text(
          'Find Your',
          style: TextStyle(
            fontFamily: 'Chewy',
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10), // Spacing
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Perfect ',
                style: TextStyle(
                  fontFamily: 'Chewy',
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'PARTNER',
                style: TextStyle(
                  fontFamily: 'Chewy',
                  fontSize: 32,
                  color: Color(0xFFFFD700), // Yellow color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper method to build the "Get Started" button
  Widget _buildButton(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.5, // 50% of the screen width
      height: screenHeight * 0.07, // Responsive height
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE9E923), // Yellow
            Color(0xFFCAA470), // Golden Brown
            Color(0xFF972EF2), // Purple
          ],
          stops: [0.0, 0.37, 1.0], // Gradient stops
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      child: const Center(
        child: Text(
          'Get Started',
          style: TextStyle(
            fontFamily: 'Poppins', // Custom font for button text
            fontSize: 16, // Font size
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold, // Bold weight
          ),
        ),
      ),
    );
  }
}
