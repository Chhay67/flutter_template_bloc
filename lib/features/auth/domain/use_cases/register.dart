

import 'package:flutter_template_bloc/core/use_cases/usecase.dart';
import 'package:flutter_template_bloc/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/session/domain/entities/user_entity.dart';

class RegisterUseCase extends UseCase<UserEntity,RegisterParams> {
  RegisterUseCase({required this.repository});
  final AuthRepository repository;

  @override
  Future<UserEntity> call(RegisterParams params) async{
   return await repository.register(userName: params.userName, password: params.password, name: params.name);
  }
}



class RegisterParams {
  RegisterParams({required this.userName,required this.password,required this.name});
  final String userName;
  final String password;
  final String name;
}