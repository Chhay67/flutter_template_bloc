
import 'package:dio/dio.dart';

class CancelDuplicateRequestsInterceptor extends Interceptor {
  final Map<String, CancelToken> _cancelTokens = {};
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    final url = options.uri.toString();
    final previousToken = _cancelTokens[url];
    if (previousToken != null) {
      previousToken.cancel('The request was manually cancelled by the user.');
    }
    final cancelToken = CancelToken();
    _cancelTokens[url] = cancelToken;
    options.cancelToken = cancelToken;
    handler.next(options);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cancelTokens.remove(response.requestOptions.uri.toString());
    handler.next(response);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _cancelTokens.remove(err.requestOptions.uri.toString());
    handler.next(err);
  }
}