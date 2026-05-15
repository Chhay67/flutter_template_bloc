

import 'package:flutter_template_bloc/core/use_cases/usecase.dart';

import '../repository/auth_repository.dart';

class LogoutUseCase extends UseCase<void,String?> {
  LogoutUseCase({required this.repository});
  final AuthRepository repository;
  @override
  Future<void> call(String? refreshToken) async {
   return repository.logout(refreshToken: refreshToken);
  }
}