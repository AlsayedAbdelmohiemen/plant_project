import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/model/weather_model.dart';
import 'ip_service.dart';


class WeatherService {
  Future<WeatherModel?> getWeatherByIP({
    required String token,
  }) async {
    try {
      final String url = 'https://green-world-vert.vercel.app//weather/ip';

      // الحصول على الـ IP العام للمستخدم
      final userIP = await getPublicIP();
      if (userIP == null) {
        print('لم يتم الحصول على عنوان الـ IP');
        return null;
      }

      final headers = {
        "token": token,
        "x-forwarded-for": userIP,
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          return WeatherModel.fromJson(responseBody['data']);
        } else {
          print('Request failed: ${responseBody['message']}');
          return null;
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception in getWeatherByIP: $e');
      return null;
    }
  }
}
