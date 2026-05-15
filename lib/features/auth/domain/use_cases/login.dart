

import 'package:flutter_template_bloc/core/use_cases/usecase.dart';
import 'package:flutter_template_bloc/features/auth/domain/entities/login_response_entity.dart';

import '../repository/auth_repository.dart';

class LoginUseCase extends UseCase<LoginResponseEntity,LoginParams> {

  LoginUseCase({required this.repository});
  final AuthRepository repository;
  @override
  Future<LoginResponseEntity> call(LoginParams params) async{
   return await repository.login(email: params.email, password: params.password);
  }
}



class LoginParams {
  LoginParams({required this.password,required this.email});
  final String email;
  final String password;
}