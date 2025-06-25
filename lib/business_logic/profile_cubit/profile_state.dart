part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  final bool showSuccessMessage;

   ProfileLoaded(this.profile, [this.showSuccessMessage = false]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProfileLoaded &&
              runtimeType == other.runtimeType &&
              profile == other.profile &&
              showSuccessMessage == other.showSuccessMessage;

  @override
  int get hashCode => profile.hashCode ^ showSuccessMessage.hashCode;
}

class ProfileError extends ProfileState {
  final String message;
   ProfileError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProfileError &&
              runtimeType == other.runtimeType &&
              message == other.message;

  @override
  int get hashCode => message.hashCode;
}