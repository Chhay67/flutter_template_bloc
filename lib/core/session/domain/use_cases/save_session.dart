
import 'package:flutter_template_bloc/core/session/domain/entities/session_entity.dart';
import 'package:flutter_template_bloc/core/use_cases/usecase.dart';

import '../repository/session_repository.dart';

class SaveSessionUseCase extends UseCase<void,SessionEntity> {

  SaveSessionUseCase({required this.repository});

  final SessionRepository repository;
  @override
  Future<void> call(SessionEntity session) async{
     return await repository.saveSession(session: session);
  }
}