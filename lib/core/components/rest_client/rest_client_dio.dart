import 'package:dio/dio.dart';
import 'package:bubblebrain/core/components/rest_client/exeption.dart';
import 'package:bubblebrain/core/constants/app_constants.dart';

class RestClientDio {
  final Dio _apiManager;

  RestClientDio()
      : _apiManager = Dio(
          BaseOptions(baseUrl: AppConstants.apiEndpoint),
        );

  Future<Response> _sendRequest<T extends Object>({
    required String path,
    required String method,
    Duration? receiveTimeout,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    try {
      final options = Options(
        headers: headers,
        method: method,
        contentType: 'application/json',
        responseType: ResponseType.json,
        receiveTimeout: receiveTimeout,
      );

      final response = await _apiManager.request<T>(
        path,
        data: body,
        options: options,
        queryParameters: queryParams,
      );

      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        Error.throwWithStackTrace(
          ConnectionException(
            message: 'ConnectionException',
            statusCode: e.response?.statusCode,
          ),
          e.stackTrace,
        );
      }
      if (e.response?.statusCode == 400) {
        Error.throwWithStackTrace(
          CustomBackendException(
            message: 'CustomBackendException',
            statusCode: e.response?.statusCode,
          ),
          e.stackTrace,
        );
      }
      if (e.response != null) {
        return e.response!;
      }
      Error.throwWithStackTrace(
        ClientException(
          message: e.toString(),
          statusCode: e.response?.statusCode,
          cause: e,
        ),
        e.stackTrace,
      );
    } on Object catch (e, stack) {
      Error.throwWithStackTrace(
        ClientException(message: e.toString(), cause: e),
        stack,
      );
    }
  }

  Future<Response> get(
    String path, {
    Duration? receiveTimeout,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _sendRequest(
        path: path,
        method: 'GET',
        headers: headers,
        queryParams: queryParams,
        receiveTimeout: receiveTimeout,
      );

  Future<Response> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Duration? receiveTimeout,
    Map<String, Object?>? queryParams,
  }) =>
      _sendRequest(
        path: path,
        method: 'POST',
        body: body,
        headers: headers,
        queryParams: queryParams,
        receiveTimeout: receiveTimeout,
      );
}
