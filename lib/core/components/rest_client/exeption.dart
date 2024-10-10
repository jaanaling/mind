abstract class RestClientException implements Exception {
  final String message;

  final int? statusCode;

  const RestClientException({required this.message, this.statusCode});
}

final class ClientException extends RestClientException {
  const ClientException({
    required super.message,
    super.statusCode,
    this.cause,
  });

  final Object? cause;

  @override
  String toString() => 'ClientException('
      'message: $message, '
      'statusCode: $statusCode, '
      'cause: $cause'
      ')';
}

final class CustomBackendException extends RestClientException {
  const CustomBackendException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'CustomBackendException('
      'message: $message, '
      'statusCode: $statusCode, '
      ')';
}

final class ConnectionException extends RestClientException {
  const ConnectionException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ConnectionException('
      'message: $message, '
      'statusCode: $statusCode, '
      ')';
}
