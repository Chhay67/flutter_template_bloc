import 'package:equatable/equatable.dart';
import 'package:flutter_template_bloc/core/session/data/models/token_model.dart';

class TokenEntity extends Equatable {
  const TokenEntity({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;


  TokenModel toModel() {
    return TokenModel(
        accessToken: accessToken,
        refreshToken: refreshToken
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
