import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../data/model/plants.dart';
import '../auth/Auth/sharedPrefrence/shared_pref.dart';
import '../weather/ip_service.dart';

class ApiServices {
  final String baseUrl = 'https://green-world-vert.vercel.app/plant';
  final String myPlantUrl = 'https://green-world-vert.vercel.app/my-plant';
  final String getSpecificPlantUrl = 'https://green-world-vert.vercel.app//plant/get-specific';

  // جلب كل النباتات باستخدام الـ token في الـ headers
  Future<List<PlantsDetail>> getAllPlants() async {
    final token = await SharedPreference.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/'),
      headers: {'token': token},
    );

    if (response.statusCode == 200) {
      final List<dynamic> plantJson = json.decode(response.body)['data'];
      return plantJson.map((json) => PlantsDetail.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load plants');
    }
  }

  // جلب نبات محدد باستخدام الـ token
  // Future<PlantModel> getSpecificPlant(String id) async {
  //   final token = await SharedPreference.getToken();
  //   if (token == null) {
  //     throw Exception('No token found');
  //   }
  //
  //   final response = await http.get(
  //     Uri.parse('$getSpecificPlantUrl/$id'),
  //     headers: {'token': token},
  //   );
  //
  //   print('API Response Status: ${response.statusCode}');
  //   print('API Response Body: ${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     if (jsonData == null || jsonData['data'] == null) {
  //       throw Exception('No plant data returned from API');
  //     }
  //
  //     return PlantModel.fromJson(jsonData['data']);
  //   } else {
  //     throw Exception('Failed to load plant - Status: ${response.statusCode}');
  //   }
  // }
  //
  // // جلب النباتات حسب الفئة باستخدام الـ token
  // Future<List<PlantModel>> getPlantsByCategory(String category) async {
  //   final token = await SharedPreference.getToken();
  //   if (token == null) {
  //     throw Exception('No token found');
  //   }
  //
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/category/$category'),
  //     headers: {'token': token},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> plantJson = json.decode(response.body)['data'];
  //     return plantJson.map((json) => PlantModel.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load plants by category');
  //   }
  // }
  //
  // // إضافة نبات إلى "My Plant" باستخدام الـ token
  // Future<void> addMyPlant(String plantId) async {
  //   final token = await SharedPreference.getToken();
  //   if (token == null) {
  //     throw Exception('No token found');
  //   }
  //
  //   final response = await http.post(
  //     Uri.parse('$myPlantUrl/add-my-plant/$plantId'),
  //     headers: {'token': token},
  //   );
  //   print('DELETE URL: $myPlantUrl/$plantId');
  //   print('Token: $token');
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     print('تم إضافة النبات إلى My Plant بنجاح');
  //   } else {
  //     throw Exception('Failed to add plant');
  //   }
  // }
  //
  // // حذف نبات من "My Plant" باستخدام الـ token
  // Future<void> deleteMyPlant(String plantId) async {
  //   final token = await SharedPreference.getToken();
  //   if (token == null) {
  //     throw Exception('No token found');
  //   }
  //
  //   final response = await http.delete(
  //     Uri.parse('$myPlantUrl/$plantId'),
  //     headers: {'token': token},
  //   );
  //   print('DELETE URL: $myPlantUrl/$plantId');
  //   print('Token: $token');
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     print('تم حذف النبات من My Plant بنجاح');
  //   } else if (response.statusCode == 404) {
  //     // النبات مش موجود، يمكننا اعتبار العملية ناجحة أو عرض رسالة مناسبة
  //     print('النبات غير موجود أو تم حذفه مسبقاً');
  //   } else {
  //     throw Exception('Failed to delete plant');
  //   }
  // }
  //
  //
  // // جلب النباتات في "My Plant" باستخدام الـ token
  // Future<List<PlantModel>> getMyPlants() async {
  //   final token = await SharedPreference.getToken();
  //   if (token == null) {
  //     throw Exception('No token found');
  //   }
  //
  //   final response = await http.get(
  //     Uri.parse('$myPlantUrl/my-plants'),
  //     headers: {'token': token},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> plantJson = json.decode(response.body)['data'];
  //     return plantJson.map((json) => PlantModel.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load my plants');
  //   }
  // }
  //
  // // جلب نبات محدد من "My Plant" باستخدام الـ token
  // Future<PlantModel> getSpecificMyPlant(String id) async {
  //   final token = await SharedPreference.getToken();
  //   if (token == null) {
  //     throw Exception('No token found');
  //   }
  //
  //   final response = await http.get(
  //     Uri.parse('$myPlantUrl/$id'),
  //     headers: {'token': token},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return PlantModel.fromJson(json.decode(response.body)['data'][0]);
  //   } else {
  //     throw Exception('Failed to load specific plant from My Plant');
  //   }
  // }
  Future<List<String>> getRecommendedPlantIds() async {
    final token = await SharedPreference.getToken();
    final userIP = await getPublicIP();

    if (token == null || userIP == null) {
      throw Exception('Token or IP not available');
    }

    final headers = {
      'token': token,
      'x-forwarded-for': userIP,
    };

    final suggestUrl = 'https://green-world-vert.vercel.app//plant/suggest';
    final suggestResponse = await http.get(Uri.parse(suggestUrl), headers: headers);

    print('Suggest API status: ${suggestResponse.statusCode}');
    print('Suggest API body: ${suggestResponse.body}');

    if (suggestResponse.statusCode == 200) {
      final data = jsonDecode(suggestResponse.body);
      final List<dynamic> plantIds = data['data'];
      return plantIds.cast<String>();
    } else {
      throw Exception('Failed to fetch suggested plant IDs');
    }
  }





}
