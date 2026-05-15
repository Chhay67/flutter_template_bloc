

import 'package:flutter_template_bloc/core/use_cases/usecase.dart';

import '../repository/session_repository.dart';

class ClearSessionUseCase extends UseCase<void,NoParams> {
  ClearSessionUseCase({required this.repository});

  final SessionRepository repository;
  @override
  Future<void> call(NoParams params) async{
   return await repository.clearSession();
  }

}