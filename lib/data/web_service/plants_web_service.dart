import 'package:dio/dio.dart';
import '../../constants/strings.dart';
import '../../presenatation/auth/Auth/sharedPrefrence/shared_pref.dart';
import '../model/main_data.dart';
import '../model/plants.dart';

class PlantWebServices {
  late Dio dio;

  PlantWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    );

    dio = Dio(options);

    // Add interceptors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          String? token = await SharedPreference.getToken();
          if (token != null && token.isNotEmpty) {
            // Try both header formats
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
          // Token might be expired - handle refresh here if needed
          print('⚠️ Unauthorized - Token might be expired');
        }
        return handler.next(error);
      },
    ));
  }

  Future<List<PlantsDetail>> getAllPlants() async {
    try {
      print('Fetching plants with current token...');
      Response response = await dio.get('plant/');

      print('API Response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        MainPlants mainPlants = MainPlants.fromJson(response.data);
        return mainPlants.data;
      } else {
        print('Server returned non-200 status: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('DioError: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response?.statusCode} - ${e.response?.data}');
      print('Headers sent: ${e.requestOptions.headers}');
      return [];
    } catch (e) {
      print('Unexpected error: $e');
      return [];
    }
  }
}