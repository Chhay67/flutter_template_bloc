

import 'package:equatable/equatable.dart';

import 'token_entity.dart';
import 'user_entity.dart';

class SessionEntity extends Equatable {
  const SessionEntity({
    required this.token,
    required this.user,
  });

  final TokenEntity token;
  final UserEntity user;

  @override
  List<Object?> get props => [token, user];
}