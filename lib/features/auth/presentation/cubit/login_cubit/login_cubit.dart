import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/app/bloc/app_session_cubit/app_session_cubit.dart';
import 'package:flutter_template_bloc/core/utils/app_logger.dart';
import 'package:flutter_template_bloc/features/auth/domain/use_cases/login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AppSessionCubit _appSessionCubit;

  LoginCubit({required AppSessionCubit appSessionCubit, required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      _appSessionCubit = appSessionCubit,
        super(LoginInitial());

  Future<void> login({required String userName, required String password}) async {
    try {
      emit(LoginLoading());
      final result = await _loginUseCase.call(
        LoginParams(password: password, userName: userName),
      );
      await _appSessionCubit.loginSuccess(
        user: result.user,
        token: result.token,
      );
      emit(LoginSuccess());
    } catch (error,stackTrace) {
      AppLogger.error(error.toString(),stackTrace: stackTrace);
      emit(LoginFailed(message: error.toString()));
    }
  }
}
