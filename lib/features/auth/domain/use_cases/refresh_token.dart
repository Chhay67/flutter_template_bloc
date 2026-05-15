

import 'package:flutter_template_bloc/core/use_cases/usecase.dart';

import '../../../../core/session/domain/entities/token_entity.dart';
import '../repository/auth_repository.dart';

class RefreshTokenUseCase extends UseCase<TokenEntity,String> {

  RefreshTokenUseCase({required this.repository});
  final AuthRepository repository;
  @override
  Future<TokenEntity> call(String refreshToken) async{
    return await repository.refreshToken(refreshToken: refreshToken);
  }
}