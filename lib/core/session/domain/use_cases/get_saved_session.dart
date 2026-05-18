




import 'package:flutter_template_bloc/core/session/domain/repository/session_repository.dart';

import '../../../use_cases/usecase.dart';
import '../../../utils/app_logger.dart';
import '../entities/session_entity.dart';

class GetSavedSessionUseCase extends UseCase<SessionEntity?,NoParams> {
  GetSavedSessionUseCase({required this.repository});

  final SessionRepository repository;
  @override
  Future<SessionEntity?> call(NoParams params) async{
    final result =  await repository.getSavedSession();
    AppLogger.info("getSavedSession: $result");
    return result;
  }

  Future<bool> hasToken() {
    return repository.hasToken();
  }

}