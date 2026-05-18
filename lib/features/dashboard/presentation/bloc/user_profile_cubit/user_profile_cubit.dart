import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/core/session/domain/entities/user_entity.dart';
import 'package:flutter_template_bloc/core/use_cases/usecase.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/use_case/get_user_profile.dart';
part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {

  final GetUserProfileUseCase _userProfileUseCase;
  UserProfileCubit(this._userProfileUseCase) : super(UserProfileInitial());


  Future<void> fetchUser() async{
    try {
      emit(UserProfileLoading());
      final result = await _userProfileUseCase.call(NoParams());
      emit(UserProfileLoaded(user: result));
    } catch (error) {
      emit(UserProfileError(message: error.toString()));
    }
  }
}
