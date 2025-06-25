import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/profile_image.dart';
import '../../data/repository/profile_repository_image.dart';
import 'image_profile_state.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  final ProfileRepositoryImage _profileRepositoryImage;
  //final ProfileCubit _profileCubit; // Remove ProfileCubit dependency

  ProfileImageCubit(this._profileRepositoryImage)
      : super(ProfileImageInitial());

  // --- Update Profile Image ---
  Future<void> updateProfileImage(File imageFile, String userId) async {
    //final profileState = _profileCubit.state; // Remove this line

    // Remove this check,  the userId is passed in.
    //if (profileState is! ProfileLoaded) {
    //  emit(ProfileImageFailure("Profile not loaded, cannot update image."));
    //  return;
    //}

    emit(ProfileImageLoading());
    try {
      final ImageProfile updatedResponse =
      await _profileRepositoryImage.updateProfileImage(
        userId: userId, // Use user ID from parameter
        imageFile: imageFile,
      );

      if (updatedResponse.success == true &&
          updatedResponse.data?.image != null) {
        emit(ProfileImageSuccess(
            updatedResponse.data!.image!)); // Emit the updated Image object
      } else {
        emit(ProfileImageFailure(updatedResponse.message ??
            'Failed to update profile image'));
      }
    } catch (e) {
      emit(ProfileImageFailure(
          'Failed to update profile image: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    //cancel any subscriptions
    return super.close();
  }
}
