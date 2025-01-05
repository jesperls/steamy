import 'dart:convert';
//import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.example.com";

  static Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return response.body;
  }
}
