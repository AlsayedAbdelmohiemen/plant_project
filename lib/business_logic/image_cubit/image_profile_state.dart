
import 'package:equatable/equatable.dart';
import 'package:final2/data/model/profile_image.dart';

// Abstract base class for Profile Image States
abstract class ProfileImageState extends Equatable {
  const ProfileImageState();

  @override
  List<Object?> get props => [];
}

// Initial state before any action
class ProfileImageInitial extends ProfileImageState {}

// State when loading profile data or performing an update
class ProfileImageLoading extends ProfileImageState {}

// State when profile data is successfully loaded or updated
class ProfileImageSuccess extends ProfileImageState {
  final Image image; // Holds the Image object from the new model

  const ProfileImageSuccess(this.image);

  @override
  List<Object?> get props => [image];
}

// State when an error occurs
class ProfileImageFailure extends ProfileImageState {
  final String error;

  const ProfileImageFailure(this.error);

  @override
  List<Object?> get props => [error];
}