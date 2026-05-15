

import 'package:flutter_template_bloc/core/session/domain/entities/token_entity.dart';
import 'package:flutter_template_bloc/core/session/domain/entities/user_entity.dart';
import 'package:flutter_template_bloc/features/auth/data/data_sources/remote_data_source.dart';
import 'package:flutter_template_bloc/features/auth/domain/entities/login_response_entity.dart';
import 'package:flutter_template_bloc/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  AuthRepositoryImpl({required this.remoteDataSource});
  final AuthRemoteDataSource remoteDataSource;
  @override
  Future<LoginResponseEntity> login({required String email, required String password})async {
    return await remoteDataSource.login(email: email, password: password);
  }

  @override
  void logout({required String? refreshToken}) async{
    return remoteDataSource.logout(refreshToken: refreshToken);
  }

  @override
  Future<TokenEntity> refreshToken({required String refreshToken}) async{
    return await remoteDataSource.refreshToken(refreshToken: refreshToken);
  }

  @override
  Future<UserEntity> register({required String email, required String password,required String name}) async{
    return await remoteDataSource.register(email: email, password: password, name: name);
  }
}