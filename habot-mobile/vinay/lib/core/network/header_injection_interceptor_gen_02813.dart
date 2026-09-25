// GEN-02813 — Header Injection Middleware for transformation_hash.
// Implements a Dio interceptor that injects the transformation_hash into every outgoing mobile request payload, with local mock hash generation and telemetry logging.

import 'dart:convert';
import 'package:dio/dio.dart';

/// Mock provider for the transformation_hash.
/// In production, this would be sourced from a secure local store or backend handshake.
class TransformationHashProvider {
  static String _cachedHash = '';

  /// Returns a deterministic mock hash for development and testing.
  static String getMockHash() {
    if (_cachedHash.isEmpty) {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final bytes = utf8.encode('udf-mobile-$timestamp');
      _cachedHash = base64Url.encode(bytes).substring(0, 32);
    }
    return _cachedHash;
  }

  /// Resets the hash (useful for testing or forced rotation).
  static void resetHash() {
    _cachedHash = '';
  }
}

/// Header Injection Middleware that injects `transformation_hash` into every mobile request.
class HeaderInjectionInterceptorGen02813 extends Interceptor {
  static const String _headerKey = 'X-Transformation-Hash';
  static const String _telemetryEventName = 'header_injection_executed';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final hash = TransformationHashProvider.getMockHash();
      options.headers[_headerKey] = hash;

      // Telemetry: Log injection event for BigQuery streaming alignment
      _logTelemetry(
        traceId: options.headers['X-Trace-Id']?.toString() ?? _generateTraceId(),
        status: 'Complete',
        path: options.path,
      );

      handler.next(options);
    } catch (e) {
      _logTelemetry(
        traceId: options.headers['X-Trace-Id']?.toString() ?? _generateTraceId(),
        status: 'Not Complete',
        path: options.path,
        error: e.toString(),
      );
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to inject transformation_hash: $e',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  String _generateTraceId() {
    return 'trace-${DateTime.now().millisecondsSinceEpoch}';
  }

  void _logTelemetry({
    required String traceId,
    required String status,
    required String path,
    String? error,
  }) {
    // Mock telemetry payload aligned with GCP/BigQuery partitioning requirements
    final telemetryPayload = {
      'event_name': _telemetryEventName,
      'event_date': DateTime.now().toIso8601String().split('T').first,
      'trace_id': traceId,
      'atomic_id': 'GEN-02813',
      'metric_name': 'Task Completion Status',
      'completion_status': status,
      'request_path': path,
      'timestamp': DateTime.now().toIso8601String(),
      if (error != null) 'error': error,
    };

    // In production, stream to telemetry service / BigQuery
    // ignore: avoid_print
    print('[GEN-02813 Telemetry]: ${jsonEncode(telemetryPayload)}');
  }
}

/// Extension to easily attach the middleware to a Dio instance.
extension DioHeaderInjectionExtension on Dio {
  /// Adds the GEN-02813 header injection middleware to the Dio interceptors.
  void addTransformationHashMiddleware() {
    interceptors.add(HeaderInjectionInterceptorGen02813());
  }
}