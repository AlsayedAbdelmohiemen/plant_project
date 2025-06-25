import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPreference {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } catch (error) {
      throw Exception('Failed to save token: $error');
    }
  }
  static Future<void> saveImagePath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', imagePath);
  }

  static Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_path');
  }

  static Future<void> saveLoginCredentials(String email, String password) async {
    try {
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'password', value: password);
    } catch (error) {
      throw Exception('Failed to save credentials: $error');
    }
  }

  static Future<Map<String, String?>> getLoginCredentials() async {
    try {
      final email = await _secureStorage.read(key: 'email');
      final password = await _secureStorage.read(key: 'password');
      return {'email': email, 'password': password};
    } catch (error) {
      throw Exception('Failed to retrieve credentials: $error');
    }
  }

  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'password');
    } catch (error) {
      throw Exception('Failed to clear data: $error');
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (error) {
      throw Exception('Failed to get token: $error');
    }
  }

  static Future<void> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
    } catch (error) {
      throw Exception('Failed to remove token: $error');
    }
  }
}