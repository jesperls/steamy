//nathalia
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  // Simulated matches data - replace this with API backend data in real implementation
  List<String> matches = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Frank",
    "Grace",
    "Hannah"
  ];

  // Search query text controller
  TextEditingController _searchController = TextEditingController();
  List<String> filteredMatches = [];

  @override
  void initState() {
    super.initState();
    filteredMatches = matches; // Initially show all matches
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredMatches = matches
          .where((match) => match.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: Column(
          children: [
            // Search bar at the top
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Matches',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Divider(),
            // Matches list below the search bar
            Expanded(
              child: filteredMatches.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredMatches.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: Icon(Icons.person, color: Colors.blue),
                            title: Text(filteredMatches[index]),
                            trailing: Icon(Icons.message, color: Colors.green),
                            onTap: () {
                              // Action when a match is clicked - Navigate to chat or message details
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Clicked on ${filteredMatches[index]}"),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No matches found.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller when not in use
    super.dispose();
  }
}
