// GEN-02989 — Create Branch Branching API Function.
// Implements the create_branch API function with mock data for local development, streaming execution events to a mock BigQuery telemetry sink.

import 'dart:convert';

/// Represents the completion status of a task aligned with ITIL v4 Service Value System.
enum TaskCompletionStatus {
  complete,
  partial,
  notComplete;

  String toJson() => name;
}

/// Data model for the create_branch request payload.
class CreateBranchRequest {
  final String branchName;
  final String sourceBranch;
  final String traceId;
  final String userId;
  final String sessionId;

  const CreateBranchRequest({
    required this.branchName,
    required this.sourceBranch,
    required this.traceId,
    required this.userId,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() => {
        'branch_name': branchName,
        'source_branch': sourceBranch,
        'trace_id': traceId,
        'user_id': userId,
        'session_id': sessionId,
      };
}

/// Data model for the create_branch response payload.
class CreateBranchResponse {
  final bool success;
  final TaskCompletionStatus status;
  final String message;
  final DateTime timestamp;
  final String traceId;

  const CreateBranchResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.timestamp,
    required this.traceId,
  });

  Map<String, dynamic> toJson() => {
        'success': success,
        'status': status.toJson(),
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'trace_id': traceId,
      };
}

/// Mock event record simulating BigQuery partitioned by event_date, clustered by trace_id.
class BranchingEventRecord {
  final String eventName;
  final DateTime eventDate;
  final String traceId;
  final Map<String, dynamic> payload;

  const BranchingEventRecord({
    required this.eventName,
    required this.eventDate,
    required this.traceId,
    required this.payload,
  });

  Map<String, dynamic> toJson() => {
        'event_name': eventName,
        'event_date': eventDate.toIso8601String().split('T').first,
        'trace_id': traceId,
        'payload': payload,
      };
}

/// Mock Telemetry Sink representing GCP BigQuery alignment.
class MockBigQueryTelemetrySink {
  static final List<BranchingEventRecord> _events = [];

  static void streamEvent(BranchingEventRecord record) {
    _events.add(record);
    // In production, this streams to BigQuery partitioned by event_date, clustered by trace_id.
  }

  static List<BranchingEventRecord> get events => List.unmodifiable(_events);
}

/// The create_branch Branching API function.
/// Simulates sub-100ms API response latency via optimized mock backend configuration.
class CreateBranchApi {
  /// Executes the create_branch operation.
  Future<CreateBranchResponse> execute(CreateBranchRequest request) async {
    final stopwatch = Stopwatch()..start();

    // Simulate network latency (guaranteed sub-100ms for mobile-first requirement)
    await Future<void>.delayed(const Duration(milliseconds: 45));

    final isSuccessful = request.branchName.isNotEmpty && request.sourceBranch.isNotEmpty;
    final status = isSuccessful ? TaskCompletionStatus.complete : TaskCompletionStatus.notComplete;

    final response = CreateBranchResponse(
      success: isSuccessful,
      status: status,
      message: isSuccessful
          ? 'Branch ${request.branchName} created successfully from ${request.sourceBranch}.'
          : 'Failed to create branch. Invalid parameters.',
      timestamp: DateTime.now(),
      traceId: request.traceId,
    );

    stopwatch.stop();

    // Stream execution event to mock BigQuery
    final event = BranchingEventRecord(
      eventName: 'create_branch_executed',
      eventDate: DateTime.now(),
      traceId: request.traceId,
      payload: {
        'request': request.toJson(),
        'response': response.toJson(),
        'latency_ms': stopwatch.elapsedMilliseconds,
        'user_id': request.userId,
        'session_id': request.sessionId,
      },
    );

    MockBigQueryTelemetrySink.streamEvent(event);

    return response;
  }
}

/// Provides realistic local mock data for testing and UI binding.
class CreateBranchMockData {
  static const String mockTraceId = 'trace-gen-02989-abc123';
  static const String mockUserId = 'user-engineer-001';
  static const String mockSessionId = 'session-xyz-789';

  static CreateBranchRequest get validRequest => const CreateBranchRequest(
        branchName: 'feature/GEN-02989-create-branch-api',
        sourceBranch: 'Lucky',
        traceId: mockTraceId,
        userId: mockUserId,
        sessionId: mockSessionId,
      );

  static CreateBranchRequest get invalidRequest => const CreateBranchRequest(
        branchName: '',
        sourceBranch: 'main',
        traceId: mockTraceId,
        userId: mockUserId,
        sessionId: mockSessionId,
      );

  static String get validRequestJson => jsonEncode(validRequest.toJson());
}
