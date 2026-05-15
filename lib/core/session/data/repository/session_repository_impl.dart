import 'package:flutter_template_bloc/core/exception/app_exception.dart';
import 'package:flutter_template_bloc/core/session/data/data_source/local_data_source.dart';
import 'package:flutter_template_bloc/core/session/domain/entities/session_entity.dart';
import 'package:flutter_template_bloc/core/session/domain/repository/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({required this.sessionLocalDataSource});

  final SessionLocalDataSource sessionLocalDataSource;

  @override
  Future<void> clearSession() async {
    try {
      await sessionLocalDataSource.clearSavedUser();
      await sessionLocalDataSource.clearSavedToken();
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<SessionEntity?> getSavedSession() async {
    try {
      final user = await sessionLocalDataSource.getSavedUser();
      final token = await sessionLocalDataSource.getSavedToken();
      if (user == null || token == null) {
        return null;
      }
      return SessionEntity(token: token, user: user);
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> saveSession({required SessionEntity session}) async {
    try {
      await sessionLocalDataSource.savedToken(token: session.token.toModel());
      await sessionLocalDataSource.savedUser(user: session.user.toModel());
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }
}
