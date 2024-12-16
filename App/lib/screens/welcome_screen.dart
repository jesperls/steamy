import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A4AE0), // Purple background color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Title "Steamy"
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  'Steamy',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Tagline "Find Your Perfect PARTNER"
              Column(
                children: [
                  Text(
                    'Find Your',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Perfect PARTNER',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700), // Yellow color for PARTNER
                    ),
                  ),
                ],
              ),
              // Background design (simulated with emoji-like icons)
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 40,
                      child: Icon(Icons.favorite,
                          size: 50, color: Color(0xFFFFD700)),
                    ),
                    Positioned(
                      bottom: 80,
                      right: 40,
                      child: Icon(Icons.favorite_border,
                          size: 50, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 40,
                      child: Icon(Icons.favorite,
                          size: 50, color: Color(0xFFFFD700)),
                    ),
                  ],
                ),
              ),
              // Footer with some shapes
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border, color: Colors.white, size: 32),
                    SizedBox(width: 20),
                    Icon(Icons.star, color: Color(0xFFFFD700), size: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
