import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chat_screen.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> matches = [];
  List<Map<String, dynamic>> newMatches = [];
  List<Map<String, dynamic>> filteredMatches = [];
  bool isLoading = true;
  bool hasFetched = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMatches();
    _searchController.addListener(_onSearchChanged);
  }

  // Fetch server data with error handling
  Future<void> _fetchMatches() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Fetch the data from the API
      final response = await http
          .post(
            Uri.parse('http://10.0.2.2:8000/getMatches'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'user_id': "1"}), // Assume user_id is "1"
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          setState(() {
            // Retain the original data transformation logic
            matches = List<Map<String, dynamic>>.from(
              data.map(
                (item) => {
                  "id": item["id"].toString(),
                  "user_id_1": item["user_id_1"].toString(),
                  "user_id_2": item["user_id_2"].toString(),
                  "match_score": item["match_score"].toString(),
                  "is_matched": item["is_matched"]?.toString() ?? "false",
                  "created_at": item["created_at"] ?? "N/A",
                  "updated_at": item["updated_at"] ?? "N/A",
                  "name": "Emily", // Placeholder name
                  "image":
                      "https://img.freepik.com/free-photo/portrait-happy-smiling-woman-standing-square-sunny-summer-spring-day-outside-cute-smiling-woman-looking-you-attractive-young-girl-enjoying-summer-filtered-image-flare-sunshine_231208-6734.jpg?semt=ais_hybrid",
                },
              ),
            );

            // Keep only the first 5 matches for display in the horizontal scroll
            newMatches = matches.take(5).toList();
          });
        } else {
          setState(() {
            matches = [];
            newMatches = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No new matches found.")),
          );
        }
      } else {
        throw Exception("Failed to load data.");
      }
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading matches: $error')),
      );
    }

    setState(() {
      isLoading = false; // Stop showing the loading indicator
      hasFetched = true;
    });
  }

  // Handle search functionality
  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      filteredMatches = matches
          .where((match) => match['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  // Navigate to the chat screen and move the match from horizontal scroll to the list
  void _navigateToChatScreen(Map<String, dynamic> user) {
    setState(() {
      // Remove match from newMatches and add to filteredMatches
      newMatches.remove(user);
      filteredMatches.add(user);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          matchedUserName: user['name']!,
          matchedUserId: int.parse(user['id']!),
        ),
      ),
    );
  }

  // Build the circular icon with shadow
  Widget _buildIcon(IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    // Header Section with circular icons and title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildIcon(Icons.person, () {
                            Navigator.pushNamed(context, '/createAccount2');
                          }), // Left icon
                          const Text(
                            'Message',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Stack(
                            children: [
                              _buildIcon(Icons.chat_bubble, () {
                                Navigator.pushNamed(context, '/message-screen');
                              }),
                              const Positioned(
                                top: 20,
                                right: 9,
                                child: Badge(),
                              ),
                            ],
                          ), // Right icon with badge
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Search Bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search Matches',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Horizontally scrollable new matches
                    newMatches.isNotEmpty
                        ? SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: newMatches.length,
                              itemBuilder: (context, index) {
                                final match = newMatches[index];
                                return GestureDetector(
                                  onTap: () => _navigateToChatScreen(match),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(match['image']!),
                                          radius: 30,
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            match['name']!,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),

                    const SizedBox(height: 10),

                    // Main list or empty state
                    filteredMatches.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text(
                                'No matches found.',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: filteredMatches.length,
                              itemBuilder: (context, index) {
                                final match = filteredMatches[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(match['image']!),
                                  ),
                                  title: Text(match['name']!),
                                  trailing: const Icon(Icons.message,
                                      color: Colors.green),
                                  onTap: () => _navigateToChatScreen(match),
                                );
                              },
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
