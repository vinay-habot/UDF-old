// GEN-03332 — ViewModel State Transition Logger for Application Flow Tracking.
// Instruments state transition logging within UDF ViewModels, streaming events to a mock telemetry sink aligned with Sentry Telemetry Guidelines and BigQuery schema expectations.

import 'dart:async';

/// Represents a single state transition event captured from a ViewModel.
class StateTransitionEvent {
  final String traceId;
  final String viewModelName;
  final String previousState;
  final String nextState;
  final DateTime timestamp;
  final String sessionId;

  const StateTransitionEvent({
    required this.traceId,
    required this.viewModelName,
    required this.previousState,
    required this.nextState,
    required this.timestamp,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() => {
        'trace_id': traceId,
        'view_model_name': viewModelName,
        'previous_state': previousState,
        'next_state': nextState,
        'event_date': timestamp.toIso8601String().substring(0, 10),
        'timestamp': timestamp.toIso8601String(),
        'session_id': sessionId,
      };
}

/// Mock telemetry sink simulating streaming to BigQuery partitioned by event_date, clustered by trace_id.
class MockTelemetrySink {
  final List<StateTransitionEvent> _buffer = [];

  void record(StateTransitionEvent event) {
    _buffer.add(event);
  }

  List<Map<String, dynamic>> flush() {
    final payload = _buffer.map((e) => e.toJson()).toList();
    _buffer.clear();
    return payload;
  }

  int get pendingCount => _buffer.length;
}

/// Mixin that instruments ViewModel state transitions for flow tracking.
/// Apply to any UDF ViewModel to automatically log state changes.
mixin ViewModelStateLogger<State> {
  final MockTelemetrySink _sink = MockTelemetrySink();
  String? _sessionId;
  int _transitionCount = 0;
  int _successfulTransitions = 0;

  /// Current state holder - must be provided by the implementing ViewModel.
  State get currentState;

  /// Name identifier for the ViewModel.
  String get viewModelName;

  void initLogger(String sessionId) {
    _sessionId = sessionId;
    _transitionCount = 0;
    _successfulTransitions = 0;
  }

  /// Logs a state transition. Call this whenever state changes in the ViewModel.
  void logStateTransition(State previousState, State nextState, {required String traceId}) {
    _transitionCount++;
    final event = StateTransitionEvent(
      traceId: traceId,
      viewModelName: viewModelName,
      previousState: previousState.toString(),
      nextState: nextState.toString(),
      timestamp: DateTime.now(),
      sessionId: _sessionId ?? 'unknown_session',
    );
    _sink.record(event);
    _successfulTransitions++;
  }

  /// Returns the State Transition Log Rate metric.
  /// Floor threshold: 0.999 per Sentry Telemetry Guidelines.
  double getStateTransitionLogRate() {
    if (_transitionCount == 0) return 1.0;
    return _successfulTransitions / _transitionCount;
  }

  /// Validates whether the metric meets the floor boundary of 0.999.
  bool isMetricPassing() {
    return getStateTransitionLogRate() >= 0.999;
  }

  /// Flushes all recorded events (simulates BigQuery stream).
  List<Map<String, dynamic>> flushEvents() {
    return _sink.flush();
  }

  /// Returns pending unflushed event count.
  int get pendingEventCount => _sink.pendingCount;
}

/// Example UDF ViewModel demonstrating the logger mixin usage.
class UdfExampleViewModel with ViewModelStateLogger<String> {
  String _state = 'Initial';

  @override
  String get currentState => _state;

  @override
  String get viewModelName => 'UdfExampleViewModel';

  void performAction(String newState, String traceId) {
    final previous = _state;
    _state = newState;
    logStateTransition(previous, newState, traceId: traceId);
  }
}
