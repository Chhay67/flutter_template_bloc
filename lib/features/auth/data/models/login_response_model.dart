import 'package:flutter_template_bloc/core/session/data/models/token_model.dart';
import 'package:flutter_template_bloc/core/session/data/models/user_model.dart';
import 'package:flutter_template_bloc/features/auth/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  LoginResponseModel({required super.user, required super.token});

  factory LoginResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      token: TokenModel.fromJson(json['tokens']),
    );
  }
}
