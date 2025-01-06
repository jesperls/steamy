import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  bool isLoading = false;
  bool matchesLeft = true;
  List<Map<String, dynamic>> discoveredUsers = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    apiService.ensureLoggedIn(context);
    _loadInitialMatches();
  }

  Future<void> _loadInitialMatches() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load first 2 matches
      for (int i = 0; i <= 2; i++) {
        await _preloadNextMatch();
      }
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading initial matches: $error')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _preloadNextMatch() async {
    try {
      final match = await apiService.fetchNextMatch();
      if (match != null) {
        setState(() {
          discoveredUsers.add(match);
        });
      } else {
        setState(() {
          matchesLeft = false;
        });
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<bool> _onSwipe(
      int index, int? secondaryIndex, CardSwiperDirection direction) async {
    if (index < 0 || index >= discoveredUsers.length) return false;

    final swipedUser = discoveredUsers[index];

    try {
      if (direction == CardSwiperDirection.right) {
        await apiService.sendMatchRequest(swipedUser['id'].toString());
      }
      _preloadNextMatch();

      return true;
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing swipe, user already matched')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    Navigator.pushNamed(context, '/editAccount');
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
                ],
              ),
            ),

            // User Card Section
            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : !matchesLeft
                        ? const Text('No more matches available')
                        : CardSwiper(
                            cardBuilder: (context,
                                index,
                                horizontalOffsetPercentage,
                                verticalOffsetPercentage) {
                              final user = discoveredUsers[index];
                              return _buildUserCard(
                                screenWidth,
                                screenHeight,
                                apiService.getBaseUrl +
                                    '/getImage/' +
                                    (user['pictures']?.firstWhere((pic) =>
                                            pic['is_profile_picture'] ==
                                            true)['picture_url'] ??
                                        ''),
                                user['display_name'] ?? 'Anonymous',
                                user['bio'] ?? 'Unknown',
                              );
                            },
                            cardsCount: discoveredUsers.length,
                            onSwipe: _onSwipe,
                            onEnd: _preloadNextMatch,
                            allowedSwipeDirection:
                                const AllowedSwipeDirection.only(
                                    up: false,
                                    down: false,
                                    left: true,
                                    right: true),
                            isLoop: false,
                          ),
              ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the "Match" button
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
        onPressed: () => (),
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
