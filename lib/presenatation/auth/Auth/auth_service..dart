import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_services.dart';

class AuthService {
  static Future<Map<String, dynamic>> signup({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        'auth/signup',
        {
          'userName': userName,
          'email': email,
          'password': password,
        },
      );

      if (response == null) {
        return {'success': false, 'message': 'No response from server'};
      }

      final responseData = jsonDecode(response.body);

      print(' Signup API Response: $responseData');
      print(' Status Code: ${response.statusCode}');
      print(' Success: ${responseData['success']}');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData['success'] == true) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'User created successfully',
          'email': email,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      print(' Signup Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        'auth/login',
        {
          'email': email,
          'password': password,
        },
      );

      if (response == null) {
        return {'error': 'No response from server'};
      }

      final responseData = jsonDecode(response.body);

      print(' Login API Response: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (responseData.containsKey('isVerified') &&
            responseData['isVerified'] == false) {
          return {
            'error': 'Your account is not verified. Please check your email.'
          };
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);

        return responseData;
      } else {
        return {'error': responseData['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> forgetPassword(String email) async {
    try {
      final response = await ApiService.post(
        'auth/forget-password',
        {'email': email},
      );

      if (response == null) {
        return {'success': false, 'message': 'No response from server'};
      }

      final responseData = jsonDecode(response.body);

      print('Forget Password API Response: $responseData');
      print(' Status Code: ${response.statusCode}');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData['success'] == true) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'OTP sent successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      print('Forget Password Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    try {
      final response = await ApiService.post(
        'auth/verify-otp',
        {'email': email, 'otp': otp},
      );

      if (response == null) {
        return {'success': false, 'message': 'No response from server'};
      }

      final responseData = jsonDecode(response.body);

      print(' Verify OTP API Response: $responseData');
      print(' Status Code: ${response.statusCode}');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData['success'] == true) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'OTP verified successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Invalid OTP',
        };
      }
    } catch (e) {
      print(' Verify OTP Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword, String confirmPassword) async {
    try {
      final response = await ApiService.post(
        'auth/reset-password',
        {
          'email': email,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (response == null) {
        return {'success': false, 'message': 'No response from server'};
      }

      final responseData = jsonDecode(response.body);

      print('Reset Password API Response: $responseData');
      print(' Status Code: ${response.statusCode}');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData['success'] == true) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Password reset successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to reset password',
        };
      }
    } catch (e) {
      print(' Reset Password Exception: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
  static Future<Map<String, dynamic>> userProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      

      if (token == null) {
        return {'success': false, 'message': 'No token found. Please login again.'};
      }

      final response = await ApiService.get(
        'auth/profile',
        headers: {
          'token': token,  
          'Content-Type': 'application/json',
        },
      );

      if (response == null) {
        return {'success': false, 'message': 'No response from server'};
      }

      final responseData = jsonDecode(response.body);

      print(' User Profile API Response: $responseData');

          if (response.statusCode == 200 && responseData['success'] == true && responseData.containsKey('data')) {
        return {
          'success': true,
          'data': responseData['data'], 
        };
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Failed to fetch profile'};
      }
    } catch (e) {
    
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }


}
