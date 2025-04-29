import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_ed_app/core/constants/endpoints.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    final options = BaseOptions(
      baseUrl: EndPoints.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        request: true,
        error: true,
      ));
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('Request Query Parameters: ${options.queryParameters}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('Response Data: ${response.data}');
        debugPrint('Response Status Code: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        print("Dio Error: ${e.message}");
        print("Dio Error Type: ${e.type}");
        if (e.response != null) {
          print("Dio Error Response Data: ${e.response?.data}");
          print("Dio Error Response Status: ${e.response?.statusCode}");
        }
        return handler.next(e);
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('--- Dio Request ---');
          debugPrint('URL: ${options.uri}');
          debugPrint('Method: ${options.method}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Query Parameters: ${options.queryParameters}');
          debugPrint('Data: ${options.data}');
          debugPrint('--- End of Request ---');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('--- Dio Response ---');
          debugPrint('Status Code: ${response.statusCode}');
          debugPrint('Data: ${response.data}');
          debugPrint('--- End of Response ---');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('--- Dio Error ---');
          debugPrint('Message: ${e.message}');
          if (e.response != null) {
            debugPrint('Status Code: ${e.response?.statusCode}');
            debugPrint('Data: ${e.response?.data}');
          }
          debugPrint('--- End of Error ---');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final Response response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
