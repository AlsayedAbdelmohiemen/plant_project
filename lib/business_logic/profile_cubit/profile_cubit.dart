import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../data/model/Profile.dart';
import '../../data/repository/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  void fetchProfile() async {
    try {
      emit(ProfileLoading());
      final profile = await profileRepository.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError("Failed to fetch profile: ${e.toString()}"));
    }
  }


}
