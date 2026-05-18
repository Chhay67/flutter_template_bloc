import 'package:flutter_template_bloc/core/network/dio_client.dart';
import 'package:flutter_template_bloc/features/auth/data/models/login_response_model.dart';

import '../../../../core/session/data/models/token_model.dart';
import '../../../../core/session/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String userName,
    required String password,
    required String name,
  });

  Future<LoginResponseModel> login({
    required String userName,
    required String password,
  });

  Future<TokenModel> refreshToken({required String refreshToken});

  void logout({required String? refreshToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.dioClient});
  final DioClient dioClient;

  static const kLogin = '/auth/login';

  static const kLogout = '/auth/logout';

  static const kRefreshToken = "/auth/refresh";

  static const kRegister = '/auth/register';

  @override
  Future<LoginResponseModel> login({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        kLogin,
        data: {"username": userName, "password": password},
      );
      return LoginResponseModel.fromJson(response.data['data']);
    } catch (_) {
      rethrow;
    }
  }

  @override
  void logout({required String? refreshToken}) {
    dioClient.post(kLogout, data: {"refreshToken": refreshToken});
  }

  @override
  Future<TokenModel> refreshToken({required String refreshToken}) async {
    try {
      final response = await dioClient.post(
        kRefreshToken,
        data: {"refreshToken": refreshToken},
      );
      return TokenModel.fromJson(response.data['data']);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register({
    required String userName,
    required String password,
    required String name,
  }) async {
    try {
      final response = await dioClient.post(
        kRegister,
        data: {"username": userName, "password": password, "name": name},
      );
      return UserModel.fromJson(response.data['data']);
    } catch (_) {
      rethrow;
    }
  }
}
