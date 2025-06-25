import 'package:dio/dio.dart';
import '../../constants/strings.dart';
import '../../presenatation/auth/Auth/sharedPrefrence/shared_pref.dart';
import '../model/Profile.dart';


class ProfileWebServices {
  late Dio dio;

  ProfileWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    );

    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          String? token = await SharedPreference.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            options.headers['token'] = token;
          }
          return handler.next(options);
        } catch (e) {
          return handler.reject(DioException(
            requestOptions: options,
            error: 'Token retrieval failed: $e',
          ));
        }
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          print('⚠️ Unauthorized - Token might be expired');
        }
        return handler.next(error);
      },
    ));
  }

  Future<Profile> getProfile() async {
    try {
      print('Fetching profile with current token...');
      Response response = await dio.get('auth/profile');

      print('API Response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        return Profile.fromJson(response.data);
      } else {
        print('Server returned non-200 status: ${response.statusCode}');
        throw Exception('Failed to load profile');
      }
    } on DioException catch (e) {
      print('DioError: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response?.statusCode} - ${e.response?.data}');
      print('Headers sent: ${e.requestOptions.headers}');
      throw Exception('Failed to load profile: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error occurred');
    }
  }

}