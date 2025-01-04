import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  bool isLoading = false;
  Future<void> _fetchMatches() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/match'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body:
            jsonEncode({"user_id": "1", "matched_id": "7", "matcher_id": "3"}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log(data.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Match request sent")),
        );
      } else {}
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading matches: $error')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const List<Map<String, String>> sampleData = [
      {
        'image':
            'https://img.freepik.com/free-photo/portrait-happy-smiling-woman-standing-square-sunny-summer-spring-day-outside-cute-smiling-woman-looking-you-attractive-young-girl-enjoying-summer-filtered-image-flare-sunshine_231208-6734.jpg?semt=ais_hybrid',
        'username': '@AnnaLarsson',
        'fullName': 'Anna Larsson',
      },
      {
        'image':
            'https://image.tensorartassets.com/cdn-cgi/image/w=600/posts/images/693605929739983953/5df558af-e772-4ee9-a5de-4a28df8bd48e.jpg',
        'username': '@JohnDoe',
        'fullName': 'John Doe',
      },
      {
        'image':
            'https://plus.unsplash.com/premium_photo-1665663927708-e3287b105c44?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YW1lcmljYW4lMjBnaXJsfGVufDB8fDB8fHww',
        'username': '@EmilySmith',
        'fullName': 'Emily Smith',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white, // White background color
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Navigation and Title
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIcon(Icons.person, () {
                    Navigator.pushNamed(context, '/createAccount2');
                  }), // Left icon
                  const Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Stack(
                    children: [
                      _buildIcon(CupertinoIcons.chat_bubble, () {
                        Navigator.pushNamed(context, '/message-screen');
                      }),
                      const Positioned(
                        top: 20,
                        right: 9,
                        child: Badge(),
                      )
                    ],
                  ), // Right icon
                ],
              ),
            ),

            // "Near You" Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'NEAR YOU',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle "View All" tap
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD9A1F2), // Purple text color
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // User Card Section
            Expanded(
              child: Center(
                child: CardSwiper(
                  cardBuilder: (context, index, horizontalOffsetPercentage,
                      verticalOffsetPercentage) {
                    final user = sampleData[index];
                    return _buildUserCard(screenWidth, screenHeight,
                        user['image']!, user['username']!, user['fullName']!);
                  },
                  cardsCount: sampleData.length,
                  allowedSwipeDirection: const AllowedSwipeDirection.only(
                      up: false, down: false, left: true, right: true),
                ),
              ),
            ),
            // "Match" Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: _buildMatchButton(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a circular icon with shadow to the left
  Widget _buildIcon(IconData icon, Function() ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  /// Builds the user card
  Widget _buildUserCard(
    double screenWidth,
    double screenHeight,
    String imageUrl,
    String username,
    String fullName,
  ) {
    return Center(
      child: Container(
        width: screenWidth * 0.85,
        height: screenHeight * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay for text visibility
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle "Follow" button tap
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the "Match" button
  Widget _buildMatchButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE9E923), // Yellow
            Color(0xFF972EF2), // Purple
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () => _fetchMatches(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              )
            : const Text(
                'Match',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
