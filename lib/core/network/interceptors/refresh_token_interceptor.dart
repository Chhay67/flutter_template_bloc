import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_template_bloc/app/bloc/app_session_cubit/app_session_cubit.dart';
import 'package:flutter_template_bloc/core/config/app_config.dart';
import 'package:flutter_template_bloc/core/session/data/models/token_model.dart';
import 'package:flutter_template_bloc/core/storage/token_storage.dart';
import 'package:flutter_template_bloc/core/utils/app_logger.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
    required AppSessionCubit appSessionCubit,
  }) : _dio = dio,
       _tokenStorage = tokenStorage,
       _appSessionCubit = appSessionCubit;
  final TokenStorage _tokenStorage;
  final AppSessionCubit _appSessionCubit;
  bool _isRefreshing = false;
  final List<({ErrorInterceptorHandler handler, RequestOptions options})>
  _pendingRequests = [];
  final Dio _dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      _pendingRequests.add((handler: handler, options: err.requestOptions));
      return;
    }

    _isRefreshing = true;
    _pendingRequests.add((handler: handler, options: err.requestOptions));

    await _tryFakeRefreshToken().then((success) async {
      _isRefreshing = false;
      final pending = List.of(_pendingRequests);
      _pendingRequests.clear();

      if (success) {
        for (final req in pending) {
          await _retryRequest(req.options).then(
            req.handler.resolve,
            onError: (e) => req.handler.next(e is DioException ? e : err),
          );
        }
      } else {
        await _onRefreshFailed();
        for (final req in pending) {
          req.handler.next(err);
        }
      }
    });
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    final token = _tokenStorage.getToken();
    if (token != null && token.accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    return _dio.fetch<dynamic>(options);
  }

  Future<void> _onRefreshFailed() async {
    _appSessionCubit.forceLogout();
  }
  Future<bool> _tryFakeRefreshToken() async {
   return false;
  }
  Future<bool> _tryRefreshToken() async {
    try {
      AppLogger.info("tryRefreshToken...");
      final token = _tokenStorage.getToken();
      AppLogger.info("local token: ${token?.toJson()}");
      if (token == null) return false;
      if (token.refreshToken.isEmpty) return false;
      final bareDio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (kDebugMode) {
        bareDio.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
            error: true,
            compact: true,
            maxWidth: 120,
          ),
        );
      }
      final response = await bareDio.post<Map<String, dynamic>>(
        '/auth/refresh-token',
        data: {'refreshToken': token.refreshToken},
      );
      AppLogger.info("response token: ${response.data}");
      final data = response.data;
      if (data == null) return false;
      final newToken = TokenModel.fromJson(response.data?['data']);
      AppLogger.info("newToken: $newToken");

      if (newToken.accessToken.isEmpty || newToken.refreshToken.isEmpty) return false;
      await _tokenStorage.saveToken(newToken);
      return true;
    } catch (error) {
      return false;
    }
  }
}
