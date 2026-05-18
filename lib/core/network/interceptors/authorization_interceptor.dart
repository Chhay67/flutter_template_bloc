import 'package:dio/dio.dart';
import 'package:flutter_template_bloc/core/storage/token_storage.dart';

import '../../session/data/models/token_model.dart';

class AuthorizationInterceptor extends Interceptor {
  AuthorizationInterceptor(this._tokenStorage);
  final TokenStorage _tokenStorage;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final TokenModel? token = _tokenStorage.getToken();

    if (token != null && token.accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
    handler.next(options);
  }
}