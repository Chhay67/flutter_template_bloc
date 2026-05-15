

import 'package:hive_ce_flutter/adapters.dart';
import '../session/data/models/token_model.dart';

class TokenStorage {
  static const String boxName = 'auth';
  static const String _tokenKey = 'token_key';

  final Box _box;

  TokenStorage(this._box);

  Future<void> saveToken(TokenModel token) async {
    await _box.put(_tokenKey, token.toJson());
  }

  TokenModel? getToken() {
    final data = _box.get(_tokenKey);

    if (data == null) return null;

    return TokenModel.fromJson(data);
  }

  String? getAccessToken() {
    return getToken()?.accessToken;
  }

  String? getRefreshToken() {
    return getToken()?.refreshToken;
  }

  Future<void> clearToken() async {
    await _box.delete(_tokenKey);
  }

  bool get hasToken {
    final token = getToken();

    return token != null &&
        token.accessToken.isNotEmpty &&
        token.refreshToken.isNotEmpty;
  }
}