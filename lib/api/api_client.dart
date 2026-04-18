// lib/api/api_client.dart
// ============================================================
// SIMAKSI - Dio HTTP Client
// Konfigurasi HTTP client dengan interceptor logging & caching
// ============================================================

import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class ApiClient {
  ApiClient._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ── Interceptors ──────────────────────────────────────
    dio.interceptors.addAll([_LoggingInterceptor(), _ErrorInterceptor()]);

    return dio;
  }

  // ── Reset (misal setelah update API key) ──────────────────
  static void reset() => _instance = null;
}

// ── Logging Interceptor ────────────────────────────────────
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API] → ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API] ← ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API] ✗ ${err.type}: ${err.message}');
    handler.next(err);
  }
}

// ── Error Interceptor ──────────────────────────────────────
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = switch (err.type) {
      DioExceptionType.connectionTimeout => 'Koneksi timeout. Coba lagi.',
      DioExceptionType.receiveTimeout =>
        'Server tidak merespon. Coba lagi nanti.',
      DioExceptionType.connectionError => 'Tidak ada koneksi internet.',
      DioExceptionType.badResponse =>
        'Server error: ${err.response?.statusCode}',
      _ => 'Terjadi kesalahan. Silakan coba lagi.',
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: message,
        type: err.type,
        response: err.response,
      ),
    );
  }
}

// ── API Result Wrapper ─────────────────────────────────────
sealed class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiError<T> extends ApiResult<T> {
  final String message;
  const ApiError(this.message);
}
