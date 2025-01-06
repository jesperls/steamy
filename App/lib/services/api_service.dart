import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:8000";

  Future<Map<String, dynamic>> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'display_name': 'User',
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMatches(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getMatches'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    throw Exception('Failed to fetch matches: ${response.body}');
  }

  Future<void> sendMatchRequest(String matcherId, String matchedId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/match'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'matcher_id': matcherId,
        'matched_id': matchedId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send match request: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> fetchNextMatch(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getNextMatch'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data != null ? data as Map<String, dynamic> : null;
    }
    throw Exception('Failed to fetch next match: ${response.body}');
  }

  Future<void> sendChatMessage(int senderId, int receiverId, String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendMessage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message_text': text,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send chat message: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchChatMessages(int userId1, int userId2) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getMessages'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id_1': userId1, 'user_id_2': userId2}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    throw Exception('Failed to fetch chat messages: ${response.body}');
  }
}
