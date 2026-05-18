

import 'package:flutter_template_bloc/core/use_cases/usecase.dart';
import 'package:flutter_template_bloc/features/auth/domain/entities/login_response_entity.dart';

import '../repository/auth_repository.dart';

class LoginUseCase extends UseCase<LoginResponseEntity,LoginParams> {

  LoginUseCase({required this.repository});
  final AuthRepository repository;
  @override
  Future<LoginResponseEntity> call(LoginParams params) async{
   return await repository.login(userName: params.userName, password: params.password);
  }
}



class LoginParams {
  LoginParams({required this.password,required this.userName});
  final String userName;
  final String password;
}