import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_screen.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, String>> matches = [];
  List<Map<String, String>> newMatches = [];
  bool isLoading = true;
  bool hasFetched = false;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredMatches = [];

  @override
  void initState() {
    super.initState();
    _fetchMatches();
    _searchController.addListener(_onSearchChanged);
  }

  // Fetch server data with error handling
  Future<void> _fetchMatches() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
      await http.get(Uri.parse('http://localhost:8000/getNextMatch'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          setState(() {
            matches = List<Map<String, String>>.from(
              data.map(
                    (item) => {
                  "name": item["name"] ?? "Unknown",
                  "image": item["image"] ?? "https://via.placeholder.com/150",
                  "id": item["id"] ?? "0",
                },
              ),
            );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading matches: $error')),
      );
    }

    setState(() {
      isLoading = false;
      hasFetched = true;
    });
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      filteredMatches = matches
          .where((match) => match['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToChatScreen(Map<String, String> user) {
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
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: Colors.blue, size: 28),
                      onPressed: () {
                        Navigator.pushNamed(context, '/create_account');
                      },
                    ),
                    const Text(
                      'Message',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.explore,
                          color: Colors.blue, size: 28),
                      onPressed: () {
                        Navigator.pushNamed(context, '/matching_page');
                      },
                    ),
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