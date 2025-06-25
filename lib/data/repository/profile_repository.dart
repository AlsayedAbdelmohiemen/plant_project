import '../model/Profile.dart';
import '../web_service/profile_web_service.dart';

class ProfileRepository {
  final ProfileWebServices profileWebServices;

  ProfileRepository(this.profileWebServices);

  Future<Profile> getProfile() async {
    try {
      return await profileWebServices.getProfile();
    } catch (e) {
      print('Error in ProfileRepository getProfile: ${e.toString()}');
      rethrow;
    }
  }


}
