

import 'package:flutter_template_bloc/core/session/domain/entities/user_entity.dart';
import 'package:flutter_template_bloc/core/use_cases/usecase.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/repository/dashboard_repository.dart';

class GetUserProfileUseCase extends UseCase<UserEntity,NoParams> {
  final DashboardRepository repository;
  GetUserProfileUseCase({required this.repository});

  @override
  Future<UserEntity> call(NoParams params) async{
    return await repository.getUserProfile();
  }


}