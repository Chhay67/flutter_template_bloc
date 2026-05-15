

import 'package:flutter_template_bloc/core/session/domain/entities/token_entity.dart';
import 'package:flutter_template_bloc/core/session/domain/entities/user_entity.dart';

class LoginResponseEntity {
  const LoginResponseEntity({required this.user,required this.token});
  final UserEntity user;
  final TokenEntity token;
}