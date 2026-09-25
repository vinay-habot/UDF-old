// GEN-02747 — Linter Gate Telemetry and Engineering Console Status Model.
// Provides data models, mock repository, and M3 UI state representation for tracking linter gate pass rates in the engineering console.

import 'package:flutter/material.dart';

/// Represents the outcome of a linter gate check.
enum LinterGateStatus {
  pass,
  fail,
}

/// Data model for a single linter gate execution event.
class LinterGateEvent {
  final String traceId;
  final DateTime eventDate;
  final String sessionId;
  final LinterGateStatus status;
  final double passRate;
  final String standardReference;

  const LinterGateEvent({
    required this.traceId,
    required this.eventDate,
    required this.sessionId,
    required this.status,
    required this.passRate,
    required this.standardReference,
  });

  factory LinterGateEvent.fromJson(Map<String, dynamic> json) {
    return LinterGateEvent(
      traceId: json['trace_id'] as String? ?? '',
      eventDate: DateTime.parse(json['event_date'] as String? ?? DateTime.now().toIso8601String()),
      sessionId: json['session_id'] as String? ?? '',
      status: (json['status'] as String?) == 'Fail' ? LinterGateStatus.fail : LinterGateStatus.pass,
      passRate: (json['pass_rate'] as num?)?.toDouble() ?? 0.0,
      standardReference: json['standard_reference'] as String? ?? 'DORA',
    );
  }

  Map<String, dynamic> toJson() => {
    'trace_id': traceId,
    'event_date': eventDate.toIso8601String(),
    'session_id': sessionId,
    'status': status == LinterGateStatus.pass ? 'Pass' : 'Fail',
    'pass_rate': passRate,
    'standard_reference': standardReference,
  };
}

/// Mock repository simulating BigQuery streaming data for linter gate events.
class LinterGateMockRepository {
  static const double _kFloorThreshold = 0.95;

  static List<LinterGateEvent> getMockEvents() {
    final now = DateTime.now();
    return [
      LinterGateEvent(
        traceId: 'trace-001-gen-02747',
        eventDate: now.subtract(const Duration(minutes: 30)),
        sessionId: 'session-eng-01',
        status: LinterGateStatus.pass,
        passRate: 1.0,
        standardReference: 'DORA — Code Quality and Static Analysis Standards',
      ),
      LinterGateEvent(
        traceId: 'trace-002-gen-02747',
        eventDate: now.subtract(const Duration(minutes: 15)),
        sessionId: 'session-eng-01',
        status: LinterGateStatus.pass,
        passRate: 0.98,
        standardReference: 'DORA — Code Quality and Static Analysis Standards',
      ),
      LinterGateEvent(
        traceId: 'trace-003-gen-02747',
        eventDate: now,
        sessionId: 'session-eng-02',
        status: LinterGateStatus.pass,
        passRate: 1.0,
        standardReference: 'DORA — Code Quality and Static Analysis Standards',
      ),
    ];
  }

  static bool evaluateCompliance(double currentPassRate) {
    return currentPassRate >= _kFloorThreshold;
  }
}

/// M3 Elevated Card widget displaying the linter gate health status.
class LinterGateStatusCard extends StatelessWidget {
  final LinterGateEvent latestEvent;

  const LinterGateStatusCard({
    super.key,
    required this.latestEvent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPassing = latestEvent.status == LinterGateStatus.pass &&
        LinterGateMockRepository.evaluateCompliance(latestEvent.passRate);

    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Linter Gate Pass Rate',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Chip(
                  label: Text(
                    isPassing ? 'Pass' : 'Fail',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isPassing ? Colors.white : Colors.white,
                    ),
                  ),
                  backgroundColor: isPassing ? Colors.green.shade700 : Colors.red.shade700,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              'Current Rate: ${(latestEvent.passRate * 100).toStringAsFixed(1)}%',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 4.0),
            Text(
              'Target Floor: 95.0%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Standard: ${latestEvent.standardReference}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Trace ID: ${latestEvent.traceId}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
