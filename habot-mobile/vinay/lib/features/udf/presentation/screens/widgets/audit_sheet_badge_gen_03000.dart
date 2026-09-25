// GEN-03000 — Audit Sheet Badge with Tap-to-View Cross-Stage Reasoning Verification.
// Implements a tappable M3 badge that opens a full cross-stage reasoning verification audit sheet via M3 Bottom Sheet. Uses mock data, 48x48dp touch targets, and Material You dynamic color.

import 'package:flutter/material.dart';

/// Mock data model for a single audit step.
class AuditStep {
  final String traceId;
  final String stageName;
  final String status; // Good, Average, Poor
  final DateTime timestamp;
  final double taskSuccessRate;

  const AuditStep({
    required this.traceId,
    required this.stageName,
    required this.status,
    required this.timestamp,
    required this.taskSuccessRate,
  });
}

/// Hardcoded mock data representing the cross-stage reasoning verification audit sheet.
const List<AuditStep> kMockAuditSteps = [
  AuditStep(
    traceId: 'trace-001-gen-03000',
    stageName: 'Data Ingestion',
    status: 'Good',
    timestamp: DateTime(2026, 9, 25, 10, 0),
    taskSuccessRate: 98.5,
  ),
  AuditStep(
    traceId: 'trace-002-gen-03000',
    stageName: 'Reasoning Validation',
    status: 'Average',
    timestamp: DateTime(2026, 9, 25, 10, 5),
    taskSuccessRate: 85.2,
  ),
  AuditStep(
    traceId: 'trace-003-gen-03000',
    stageName: 'Cross-Stage Sync',
    status: 'Good',
    timestamp: DateTime(2026, 9, 25, 10, 12),
    taskSuccessRate: 92.0,
  ),
  AuditStep(
    traceId: 'trace-004-gen-03000',
    stageName: 'Mobile UX Rendering',
    status: 'Poor',
    timestamp: DateTime(2026, 9, 25, 10, 18),
    taskSuccessRate: 74.1,
  ),
];

/// A tappable badge widget that triggers the full audit sheet bottom sheet.
class AuditSheetBadge extends StatelessWidget {
  const AuditSheetBadge({super.key});

  void _showAuditSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (BuildContext context) {
        return const _AuditSheetContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'View full cross-stage reasoning verification audit sheet',
      child: InkWell(
        onTap: () => _showAuditSheet(context),
        borderRadius: BorderRadius.circular(16.0),
        // 48x48dp minimum touch target per M3 guidelines
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Audit Sheet',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal content of the M3 Bottom Sheet displaying the audit steps.
class _AuditSheetContent extends StatelessWidget {
  const _AuditSheetContent();

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'Good':
        return colorScheme.primary;
      case 'Average':
        return colorScheme.tertiary;
      case 'Poor':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                width: 32.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Cross-Stage Reasoning Verification',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1.0),
            // List of audit steps using M3 Elevated Cards Level 2 (3dp)
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: kMockAuditSteps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                itemBuilder: (BuildContext context, int index) {
                  final AuditStep step = kMockAuditSteps[index];
                  return Card(
                    elevation: 3.0, // M3 Elevated Card Level 2
                    surfaceTintColor: colorScheme.surfaceTint,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  step.stageName,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // M3 Status Chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(step.status, colorScheme)
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  step.status,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: _getStatusColor(step.status, colorScheme),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              Icon(Icons.fingerprint, size: 16.0, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Text(
                                  step.traceId,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontFamily: 'monospace',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Success Rate: ${step.taskSuccessRate.toStringAsFixed(1)}%',
                                style: textTheme.bodyMedium,
                              ),
                              Text(
                                '${step.timestamp.year}-${step.timestamp.month.toString().padLeft(2, '0')}-${step.timestamp.day.toString().padLeft(2, '0')} '
                                '${step.timestamp.hour.toString().padLeft(2, '0')}:${step.timestamp.minute.toString().padLeft(2, '0')}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}