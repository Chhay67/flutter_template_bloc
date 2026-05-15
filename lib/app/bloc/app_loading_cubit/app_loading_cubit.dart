import 'package:flutter_bloc/flutter_bloc.dart';


class AppLoadingCubit extends Cubit<int> {
  AppLoadingCubit() : super(0);

  bool get isLoading => state > 0;

  void show() {
    emit(state + 1);
  }

  void hide() {
    if (state <= 0) return;

    emit(state - 1);
  }

  void reset() {
    emit(0);
  }
}