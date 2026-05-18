

import 'package:flutter_template_bloc/core/session/domain/entities/token_entity.dart';
import 'package:flutter_template_bloc/core/session/domain/entities/user_entity.dart';

import '../entities/login_response_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> register({required String userName,required String password,required String name});

  Future<LoginResponseEntity> login({required String userName,required String password});

  Future<TokenEntity> refreshToken({required String refreshToken});

  void logout({required String? refreshToken});
}