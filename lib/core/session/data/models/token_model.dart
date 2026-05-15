import '../../domain/entities/token_entity.dart';

class TokenModel extends TokenEntity {
  const TokenModel({required super.accessToken, required super.refreshToken});

  factory TokenModel.fromJson(Map<dynamic, dynamic> json) {
    return TokenModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
