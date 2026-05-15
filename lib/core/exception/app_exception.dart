


abstract class AppException implements Exception {
  const AppException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;

}

class ServerException extends AppException {
  ServerException({required super.message, super.statusCode});
  
}

class CacheException extends AppException {
  CacheException({required super.message, super.statusCode});

}
