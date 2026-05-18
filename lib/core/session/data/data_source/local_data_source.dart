import 'package:flutter_template_bloc/core/session/data/models/token_model.dart';
import 'package:flutter_template_bloc/core/session/data/models/user_model.dart';
import 'package:flutter_template_bloc/core/storage/token_storage.dart';
import 'package:flutter_template_bloc/core/storage/user_storage.dart';

abstract class SessionLocalDataSource {
  Future<void> savedUser({required UserModel user});

  Future<UserModel?> getSavedUser();

  Future<void> clearSavedUser();

  Future<void> savedToken({required TokenModel token});

  Future<TokenModel?> getSavedToken();

  Future<void> clearSavedToken();

  Future<bool> hasToken();
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  SessionLocalDataSourceImpl({
    required this.userStorage,
    required this.tokenStorage,
  });

  final TokenStorage tokenStorage;
  final UserStorage userStorage;

  @override
  Future<void> clearSavedToken() async {
    return await tokenStorage.clearToken();
  }

  @override
  Future<void> clearSavedUser() async {
    return await userStorage.clearUser();
  }

  @override
  Future<TokenModel?> getSavedToken() async {
    return tokenStorage.getToken();
  }

  @override
  Future<UserModel?> getSavedUser() async {
    return userStorage.getUser();
  }

  @override
  Future<void> savedToken({required TokenModel token}) async {
    return await tokenStorage.saveToken(token);
  }

  @override
  Future<void> savedUser({required UserModel user}) async {
    return await userStorage.saveUser(user);
  }

  @override
  Future<bool> hasToken() async {
    return tokenStorage.hasToken;
  }
}
