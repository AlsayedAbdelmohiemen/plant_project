import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart'; // Add this import
import '../../presenatation/auth/Auth/sharedPrefrence/shared_pref.dart';

class ProfileWebServiceImage {
  late Dio dio;

  ProfileWebServiceImage() {
    BaseOptions options = BaseOptions(
      baseUrl: "https://green-world-vert.vercel.app/",
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

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

  Future<Map<String, dynamic>> updateProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final mimeType = lookupMimeType(imageFile.path); // Now this will work
      final mediaType = mimeType != null
          ? MediaType.parse(mimeType)
          : MediaType('image', 'jpeg');

      final fileName = imageFile.path.split('/').last;

      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: mediaType,
        ),
      });

      final response = await dio.patch(
        'auth/profile/image',
        data: formData,
      );

      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update profile image');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("An unexpected error occurred while uploading image: $e");
    }
  }

  String _handleDioError(DioException error) {
    String errorDescription = "";
    switch (error.type) {
      case DioExceptionType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        errorDescription = "Invalid response: ${error.response?.statusCode}";
        if (error.response?.data is Map &&
            error.response?.data['message'] != null) {
          errorDescription = error.response!.data['message'];
        }
        break;
      case DioExceptionType.connectionError:
        errorDescription = "Connection error: Check network connection";
        break;
      case DioExceptionType.unknown:
        errorDescription = "Unexpected error: ${error.message}";
        break;
      case DioExceptionType.badCertificate:
        errorDescription = "Bad certificate error";
        break;
    }
    return errorDescription;
  }
}