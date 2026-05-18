
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/features/auth/domain/use_cases/register.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {

  final RegisterUseCase _registerUseCase;
  RegisterCubit(this._registerUseCase) : super(RegisterInitial());



  Future<void> register({required String name,required String userName,required String password})async{
    try {
      emit(RegisterLoading());
      await _registerUseCase.call(RegisterParams(userName: userName, password: password, name: name));
      emit(RegisterSuccess());
    } catch (error) {
      emit(RegisterError(message: error.toString()));
    }
  }
}
