import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/core/exception/app_exception.dart';
import 'package:flutter_template_bloc/core/session/domain/entities/session_entity.dart';
import 'package:flutter_template_bloc/core/session/domain/entities/token_entity.dart';
import 'package:flutter_template_bloc/core/session/domain/entities/user_entity.dart';
import 'package:flutter_template_bloc/core/session/domain/use_cases/clear_session.dart';
import 'package:flutter_template_bloc/core/session/domain/use_cases/get_saved_session.dart';
import 'package:flutter_template_bloc/core/session/domain/use_cases/save_session.dart';
import 'package:flutter_template_bloc/core/utils/app_logger.dart';

import '../../../core/use_cases/usecase.dart';
import '../../route/app_router.dart';

part 'app_session_state.dart';

class AppSessionCubit extends Cubit<SessionState> {
  AppSessionCubit({
    required GetSavedSessionUseCase getSavedSessionUseCase,
    required ClearSessionUseCase clearSessionUseCase,
    required SaveSessionUseCase saveSessionUseCase,
  }) : _clearSessionUseCase = clearSessionUseCase,
      _getSavedSessionUseCase = getSavedSessionUseCase,
      _saveSessionUseCase = saveSessionUseCase,
        super(SessionInitial());

  final GetSavedSessionUseCase _getSavedSessionUseCase;
  final SaveSessionUseCase _saveSessionUseCase;
  final ClearSessionUseCase _clearSessionUseCase;
  Future<void> onAppStart() async {
    try {
      emit(const SessionLoading());
      final session = await _getSavedSessionUseCase.call(const NoParams());
      if (session == null) {
        throw CacheException(message: 'Session restore failed.');
      }
      emit(SessionAuthenticated(session: session));
    } catch (error, stackTrace) {

      AppLogger.error(error.toString(), stackTrace: stackTrace);
      await _clearSessionUseCase.call(const NoParams());
      emit(SessionUnauthenticated(reason: "Unauthenticated : ${error.toString()}"));

    }
  }

  Future<void> loginSuccess({
    required TokenEntity token,
    required UserEntity user,
  }) async {
    final session = SessionEntity(token: token, user: user);
    await _saveSessionUseCase.call(session);

    emit(SessionAuthenticated(session: session));
  }

  Future<void> forceLogout({String? reason}) async {
    await _clearSessionUseCase.call(const NoParams());

    emit(SessionUnauthenticated(reason: reason));
  }

  // Future<void> clearSession() async {
  //   await forceLogout();
  // }
}
