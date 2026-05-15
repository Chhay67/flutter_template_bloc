part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}


final class LoginLoading extends LoginState{}

final class LoginSuccess extends LoginState{}


final class LoginFailed extends LoginState{
  LoginFailed({required this.message});
  final String message;
}