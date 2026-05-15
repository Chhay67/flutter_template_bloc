


import '../entities/session_entity.dart';

abstract class SessionRepository {

  Future<SessionEntity?> getSavedSession();
  Future<void> saveSession({required SessionEntity session});

  Future<void> clearSession();
}