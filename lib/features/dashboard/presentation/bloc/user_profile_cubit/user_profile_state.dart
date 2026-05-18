part of 'user_profile_cubit.dart';

@immutable
sealed class UserProfileState {}

final class UserProfileInitial extends UserProfileState {}


final class UserProfileLoading extends UserProfileState{}


final class UserProfileLoaded extends UserProfileState{
  final UserEntity user;
  UserProfileLoaded({required this.user});
}

final class UserProfileError extends UserProfileState{
  final String message;

  UserProfileError({required this.message});
}