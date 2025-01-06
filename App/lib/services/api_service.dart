import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "http://localhost:8000";

  String get getBaseUrl => baseUrl;

  Future<bool> ensureLoggedIn(context) async {
    final userId = await SharedPreferences.getInstance().then((prefs) => prefs.getString('userId'));
    if (userId == null) {
      Navigator.pushReplacementNamed(context, '/');
    }
    return userId != null;
  }

  Future<Map<String, dynamic>> registerUser(String email, String password, String displayName, {String? bio, String? preferences, double? locationLat, double? locationLon}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'display_name': displayName,
        'bio': bio,
        'preferences': preferences,
        'location_lat': locationLat,
        'location_lon': locationLon,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await SharedPreferences.getInstance().then((prefs) => prefs.setString('userId', data['id'].toString()));
      return data;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await SharedPreferences.getInstance().then((prefs) => prefs.setString('userId', data['id'].toString()));
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMatches() async {
    final userId = await SharedPreferences.getInstance().then((prefs) => prefs.getString('userId'));

    if (userId == null) {
      throw Exception('User not logged in');
    }
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

  Future<void> sendMatchRequest(String matchedId) async {
    final userId = await SharedPreferences.getInstance().then((prefs) => prefs.getString('userId'));
    final response = await http.post(
      Uri.parse('$baseUrl/match'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'matcher_id': userId,
        'matched_id': matchedId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send match request: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> fetchNextMatch() async {
    final userId = await SharedPreferences.getInstance().then((prefs) => prefs.getString('userId'));
    final response = await http.post(
      Uri.parse('$baseUrl/getNextMatch'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data != null ? data as Map<String, dynamic> : null;
    }
    throw Exception('Failed to fetch next match: ${response.body}');
  }

  Future<void> sendChatMessage(int receiverId, String text) async {
    final userId = await SharedPreferences.getInstance().then((prefs) => prefs.getString('userId'));
    final response = await http.post(
      Uri.parse('$baseUrl/sendMessage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sender_id': userId,
        'receiver_id': receiverId,
        'message_text': text,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send chat message: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchChatMessages(int userId2) async {
    final userId = await SharedPreferences.getInstance().then((prefs) => prefs.getString('userId'));
    final response = await http.post(
      Uri.parse('$baseUrl/getMessages'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id_1': userId, 'user_id_2': userId2}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    throw Exception('Failed to fetch chat messages: ${response.body}');
  }

  Future<Map<String, dynamic>> updateProfile(int id, {
    String? email,
    String? displayName,
    String? bio,
    String? profilePic,
    double? locationLat,
    double? locationLon
  }) async {
    final body = {
      'id': id,
      'email': email,
      'display_name': displayName,
      'bio': bio,
      'profile_pic': profilePic,
      'location_lat': locationLat,
      'location_lon': locationLon,
    };

    // Remove null values
    body.removeWhere((key, value) => value == null);

    final response = await http.put(
      Uri.parse('$baseUrl/updateProfile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Optionally update shared preferences if needed
      return data;
    } else {
      throw Exception('Profile update failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getProfile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': id}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user profile: ${response.body}');
    }
  }
}
