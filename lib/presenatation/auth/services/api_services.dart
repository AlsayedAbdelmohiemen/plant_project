import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://green-world-vert.vercel.app";

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'}, // استخدام headers إذا وُجدت
      );
      print("🔵 GET Request Headers: $headers");
      return response;
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}



