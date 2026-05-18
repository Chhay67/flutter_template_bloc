

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template_bloc/app/bloc/app_loading_cubit/app_loading_cubit.dart';
import 'package:flutter_template_bloc/app/bloc/app_session_cubit/app_session_cubit.dart';
import 'package:flutter_template_bloc/core/network/interceptors/loading_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../exception/app_exception.dart';
import '../storage/token_storage.dart';
import 'interceptors/authorization_interceptor.dart';
import 'interceptors/cancel_duplicate_requests_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';

class DioClient {
  DioClient({required String baseUrl, required this.tokenStorage,required this.appLoadingCubit,required this.appSessionCubit})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
            responseType: ResponseType.json,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.addAll([
      //LocaleInterceptor(),
      LoadingInterceptor(appLoadingCubit: appLoadingCubit),
      AuthorizationInterceptor(tokenStorage),
      RefreshTokenInterceptor(tokenStorage: tokenStorage,dio: _dio, appSessionCubit: appSessionCubit),
      // CancelDuplicateRequestsInterceptor(),
    ]);

    if (kDebugMode) {
      _dio.interceptors.add(
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
  }

  final Dio _dio;

  Dio get dio => _dio;
  final TokenStorage tokenStorage;
  final AppLoadingCubit appLoadingCubit;

  final AppSessionCubit appSessionCubit;

  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _request<T>(
          () =>
          _dio.get<T>(path, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response<T>> post<T>(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _request<T>(
          () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> put<T>(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _request<T>(
          () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> patch<T>(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _request<T>(
          () => _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> delete<T>(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _request<T>(
          () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> _request<T>(
      Future<Response<T>> Function() request,
      ) async {
    try {
      final response = await request();

      _parseOrThrow(response: response);

      return response;
    } on DioException catch (exception) {
      throw _mapDioException(exception);
    } catch (_) {
      throw ServerException(message: 'Unexpected error occurred');
    }
  }

  ServerException _mapDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final responseData = exception.response?.data;

    switch (exception.type) {
      case DioExceptionType.cancel:
        return ServerException(message: 'Request was cancelled.');

      case DioExceptionType.connectionTimeout:
        return ServerException(message: 'Connection timeout.');

      case DioExceptionType.receiveTimeout:
        return ServerException(message: 'Receive timeout.');

      case DioExceptionType.sendTimeout:
        return ServerException(message: 'Send timeout.');

      case DioExceptionType.connectionError:
        return ServerException(message: 'No internet connection.');

      case DioExceptionType.badCertificate:
        return ServerException(message: 'Bad certificate.');

      case DioExceptionType.badResponse:
        return ServerException(
          message: _handleBadResponse(statusCode, responseData),
          statusCode: statusCode,
        );

      case DioExceptionType.unknown:
        if (exception.error is SocketException ||
            exception.message?.contains('SocketException') == true) {
          return ServerException(message: 'Connection error.');
        }

        return ServerException(message: 'Unexpected error.');
    }
  }

  String _handleBadResponse(int? statusCode, dynamic data) {
    final serverMessage = _extractServerMessage(data);

    if (serverMessage != null && serverMessage.isNotEmpty) {
      return serverMessage;
    }

    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden request.';
      case 404:
        return 'Data not found.';
      case 422:
        return 'Validation error.';
      case 500:
        return 'Internal server error.';
      case 502:
        return 'Bad gateway.';
      case 503:
        return 'Service unavailable.';
      default:
        return 'Server error occurred.';
    }
  }

  String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['error'] ??
          data['errorMessage'] ??
          data['detail'];
    }

    return null;
  }
}


void _parseOrThrow({
  required Response response,
}) {
  final isSuccess = response.data['success'] ?? false;

  if (isSuccess) return;

  final errorMessage =
      response.data['message'] ?? 'Unknown error';

  throw ServerException(
    message: errorMessage,
    statusCode: response.statusCode,
  );
}