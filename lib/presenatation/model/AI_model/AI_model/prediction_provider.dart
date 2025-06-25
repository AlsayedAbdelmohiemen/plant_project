import 'dart:io';
import 'package:final2/presenatation/model/AI_model/AI_model/prediction_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PredictionProvider with ChangeNotifier {
  PredictionResult? result;
  bool isLoading = false;
  String language = 'ar'; // Default to English

  // Update the language
  void setLanguage(String langCode) {
    language = langCode;
    print('Language updated to: $language'); // Debug print
  }

  Future<void> predictImage(File imageFile) async {
    isLoading = true;
    notifyListeners();

    final uri = Uri.parse("https://406d-156-199-250-144.ngrok-free.app/predict?lang=$language");
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonMap = json.decode(responseBody);
      result = PredictionResult.fromJson(jsonMap);
    } else {
      result = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
