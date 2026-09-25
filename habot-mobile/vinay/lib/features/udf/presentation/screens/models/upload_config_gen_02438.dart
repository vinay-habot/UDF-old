// GEN-02438 — Upload Configuration Constants and Validation Utilities.
// Defines acceptable MIME types, file size limits, and provides validation helpers for upload workflows using Material 3 design tokens.

/// Acceptable MIME types for uploads as defined by architecture governance.
const List<String> kAcceptableMimeTypesGen02438 = <String>[
  'image/jpeg',
  'image/png',
  'image/webp',
  'application/pdf',
  'text/csv',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
];

/// Maximum allowed file size in bytes (10 MB).
const int kMaxFileSizeBytesGen02438 = 10 * 1024 * 1024;

/// Minimum allowed file size in bytes (1 KB).
const int kMinFileSizeBytesGen02438 = 1024;

/// Polling interval for background refresh in seconds.
const int kPollingIntervalSecondsGen02438 = 30;

/// Touch target dimension in logical pixels per M3 specification.
const double kTouchTargetSizeGen02438 = 48.0;

/// Elevation for M3 Elevated Cards Level 2.
const double kElevatedCardLevel2ElevationGen02438 = 3.0;

/// Breakpoint for single-column mobile layout.
const double kMobileBreakpointGen02438 = 600.0;

/// Breakpoint for multi-column desktop layout.
const double kDesktopBreakpointGen02438 = 840.0;

/// Enum representing the qualitative output states for process completion.
enum ProcessCompletionStatusGen02438 {
  complete,
  partial,
  notComplete;

  String get label {
    switch (this) {
      case ProcessCompletionStatusGen02438.complete:
        return 'Complete';
      case ProcessCompletionStatusGen02438.partial:
        return 'Partial';
      case ProcessCompletionStatusGen02438.notComplete:
        return 'Not Complete';
    }
  }
}

/// Validates whether a given MIME type is acceptable for upload.
bool isMimeTypeAcceptableGen02438(String mimeType) {
  return kAcceptableMimeTypesGen02438.contains(mimeType.toLowerCase().trim());
}

/// Validates whether a given file size in bytes falls within acceptable limits.
bool isFileSizeAcceptableGen02438(int fileSizeBytes) {
  return fileSizeBytes >= kMinFileSizeBytesGen02438 &&
      fileSizeBytes <= kMaxFileSizeBytesGen02438;
}

/// Evaluates the overall validity of a file based on MIME type and size.
ProcessCompletionStatusGen02438 evaluateUploadReadinessGen02438({
  required String mimeType,
  required int fileSizeBytes,
}) {
  final bool mimeValid = isMimeTypeAcceptableGen02438(mimeType);
  final bool sizeValid = isFileSizeAcceptableGen02438(fileSizeBytes);

  if (mimeValid && sizeValid) {
    return ProcessCompletionStatusGen02438.complete;
  } else if (mimeValid || sizeValid) {
    return ProcessCompletionStatusGen02438.partial;
  } else {
    return ProcessCompletionStatusGen02438.notComplete;
  }
}

/// Mock telemetry event model aligned with GCP BigQuery streaming requirements.
class UploadConfigTelemetryEventGen02438 {
  const UploadConfigTelemetryEventGen02438({
    required this.traceId,
    required this.eventDate,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.completionStatus,
    required this.timestamp,
    required this.userId,
    required this.sessionId,
  });

  final String traceId;
  final DateTime eventDate;
  final String mimeType;
  final int fileSizeBytes;
  final ProcessCompletionStatusGen02438 completionStatus;
  final DateTime timestamp;
  final String userId;
  final String sessionId;

  Map<String, dynamic> toBigQueryRow() {
    return <String, dynamic>{
      'trace_id': traceId,
      'event_date': eventDate.toIso8601String().split('T').first,
      'mime_type': mimeType,
      'file_size_bytes': fileSizeBytes,
      'completion_status': completionStatus.label,
      'timestamp': timestamp.toIso8601String(),
      'user_id': userId,
      'session_id': sessionId,
    };
  }
}

/// Generates a mock telemetry event for local testing without backend dependency.
UploadConfigTelemetryEventGen02438 generateMockTelemetryEventGen02438() {
  final DateTime now = DateTime.now();
  return UploadConfigTelemetryEventGen02438(
    traceId: 'trace-gen-02438-${now.millisecondsSinceEpoch}',
    eventDate: now,
    mimeType: 'application/pdf',
    fileSizeBytes: 5 * 1024 * 1024,
    completionStatus: ProcessCompletionStatusGen02438.complete,
    timestamp: now,
    userId: 'mock-user-001',
    sessionId: 'mock-session-abc',
  );
}