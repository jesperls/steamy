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

  Future<void> _fetchMatches() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/getMatches'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'user_id': 1}), // Send user_id as integer
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("Decoded response: $data");

        if (data is List && data.isNotEmpty) {
          setState(() {
            matches = List<Map<String, dynamic>>.from(
              data.map(
                (item) => {
                  "id": item["id"].toString(),
                  "user_id_1": item["user_id_1"].toString(),
                  "user_id_2": item["user_id_2"].toString(),

                  "is_matched": item["is_matched"]?.toString() ?? "false",
                  "created_at": item["created_at"] ?? "N/A",
                  "updated_at": item["updated_at"] ?? "N/A",
                  "name": item["name"] ?? "Unknown", // Use name from backend
                  "image": item["image"] ??
                      "default_image_url_here", // Use image URL from backend
                },
              ),
            );
            newMatches = matches.take(5).toList();
            log("Matches populated: $matches");
            log("New matches populated: $newMatches");
          });
        } else {
          log("No valid data found in response.");
          setState(() {
            matches = [];
            newMatches = [];
          });
        }
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (error) {
      log("Error fetching matches: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading matches: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
        hasFetched = true;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      filteredMatches = matches
          .where((match) => match['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToChatScreen(Map<String, dynamic> user) {
    setState(() {
      // Only add the user to filteredMatches if they are not already in it
      if (!filteredMatches.any((match) => match['id'] == user['id'])) {
        filteredMatches.add(user);
      }
      newMatches.remove(user);
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildIcon(Icons.person, () {
                            // Navigate to Create Profile page
                            Navigator.pushNamed(context, '/createAccount2');
                          }),
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
                              _buildIcon(Icons.explore, () {
                                // Navigate to Explore page
                                Navigator.pushNamed(context, '/matching_page');
                              }),
                              const Positioned(
                                top: 20,
                                right: 9,
                                child: Badge(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    filteredMatches.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text(
                                'No ongoing chats.',
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
