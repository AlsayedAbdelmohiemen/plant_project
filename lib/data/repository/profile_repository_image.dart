// profile_repository_image.dart
import 'dart:io';
import '../model/profile_image.dart';
import '../web_service/profile_web_services.dart'; // Ensure correct import path

class ProfileRepositoryImage {
  final ProfileWebServiceImage _profileWebService;

  ProfileRepositoryImage(this._profileWebService);

  Future<ImageProfile> updateProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final response = await _profileWebService.updateProfileImage(
        userId: userId,
        imageFile: imageFile,
      );
      return ImageProfile.fromJson(response); // Parse the response using the new model
    } catch (e) {
      print("Error in ProfileRepository.updateProfileImage: $e");
      rethrow;
    }
  }
}