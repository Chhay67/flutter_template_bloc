import 'package:dio/dio.dart';
import '../../../app/bloc/app_loading_cubit/app_loading_cubit.dart';

class LoadingInterceptor extends Interceptor {
  LoadingInterceptor({
    required AppLoadingCubit appLoadingCubit,
  }) : _appLoadingCubit = appLoadingCubit;

  final AppLoadingCubit _appLoadingCubit;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _appLoadingCubit.show();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _appLoadingCubit.hide();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _appLoadingCubit.hide();
    handler.next(err);
  }
}