import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // List of hearts with properties
    final List<Map<String, dynamic>> hearts = [
      {
        'image': 'assets/images/heart1.png',
        'top': 0.05,
        'left': 0.05,
        'width': 0.12,
        'height': 0.06
      },
      {
        'image': 'assets/images/heart5.png',
        'top': 0.05,
        'right': 0.05,
        'width': 0.12,
        'height': 0.06
      },
      {
        'image': 'assets/images/heart3.png',
        'top': 0.42,
        'left': 0.1,
        'width': 0.1,
        'height': 0.05
      },
      {
        'image': 'assets/images/heart4.png',
        'top': 0.42,
        'right': 0.1,
        'width': 0.1,
        'height': 0.05
      },
      {
        'image': 'assets/images/heart5.png',
        'bottom': 0.15,
        'left': 0.05,
        'width': 0.12,
        'height': 0.06
      },
      {
        'image': 'assets/images/heart6.png',
        'bottom': 0.15,
        'center': true,
        'width': 0.15,
        'height': 0.08
      },
    ];

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 86, 55, 157),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Render all hearts dynamically
            ...hearts.map((heart) => _buildHeart(
              heart['image'],
              screenWidth,
              screenHeight,
              heart['top'],
              heart['left'],
              heart['right'],
              heart['bottom'],
              heart['width'],
              heart['height'],
              isCenter: heart['center'] ?? false,
            )),

            // Footer Sticker
            _buildFooterSticker('assets/images/footer_sticker.png', screenWidth),

            // Main Title, Tagline, and Buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitle(),
                const SizedBox(height: 20),
                _buildTagline(),
                const SizedBox(height: 40),
                _buildButton(context, screenWidth, screenHeight), // "Get Started" button
//                const SizedBox(height: 20), // Space between the buttons
//                _buildMatchingPageButton(context, screenWidth, screenHeight), // "Go to Matching Page" button
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build hearts dynamically
  Widget _buildHeart(
      String asset,
      double screenWidth,
      double screenHeight,
      double? top,
      double? left,
      double? right,
      double? bottom,
      double width,
      double height, {
        bool isCenter = false,
      }) {
    return Positioned(
      top: top != null ? screenHeight * top : null,
      left: isCenter ? null : (left != null ? screenWidth * left : null),
      right: right != null ? screenWidth * right : null,
      bottom: bottom != null ? screenHeight * bottom : null,
      child: Image.asset(
        asset,
        width: screenWidth * width,
        height: screenHeight * height,
      ),
    );
  }

  /// Footer Sticker at the bottom
  Widget _buildFooterSticker(String asset, double width) {
    return Positioned(
      bottom: 0,
      child: Image.asset(
        asset,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }

  /// "Steamy" title
  Widget _buildTitle() {
    return const Text(
      'Steamy',
      style: TextStyle(
        fontFamily: 'CherryBombOne',
        fontSize: 95,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Tagline "Find Your Perfect PARTNER"
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
        const SizedBox(height: 10),
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
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// "Get Started" button
  Widget _buildButton(BuildContext context, double screenWidth, double screenHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = constraints.maxWidth * 0.6;
        final buttonHeight = 50.0;

        return Center(
          child: Container(
            width: buttonWidth.clamp(200.0, 400.0),
            height: buttonHeight,
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
                Navigator.pushNamed(context, '/onboarding');
              },
              child: const Text(
                'Get Started',
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
      },
    );
  }

  /// "Go to Matching Page" button
  Widget _buildMatchingPageButton(BuildContext context, double screenWidth, double screenHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = constraints.maxWidth * 0.6;
        final buttonHeight = 50.0;

        return Center(
          child: Container(
            width: buttonWidth.clamp(200.0, 400.0),
            height: buttonHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF56CCF2),
                  Color(0xFF2F80ED),
                ],
                stops: [0.0, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/matching_page');
              },
              child: const Text(
                'Go to Matching Page',
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
      },
    );
  }
}
