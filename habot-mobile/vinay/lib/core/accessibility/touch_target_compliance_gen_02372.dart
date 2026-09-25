// GEN-02372 — Touch Target Compliance Utility and M3 Status Card.
// Enforces strictly >= 48x48dp touch targets for sliders and buttons per Material Design 3 and WCAG 2.2 AA standards.

import 'package:flutter/material.dart';

/// Minimum touch target size in logical pixels (dp) per MD3 and WCAG 2.2 AA.
const double kMinTouchTargetSizeGen02372 = 48.0;

/// Metric configuration constants.
const String kMetricNameGen02372 = 'UI Compliance Rate (%)';
const double kFloorBoundaryGen02372 = 0.95;
const double kOptimalTargetGen02372 = 1.0;
const double kCeilingBoundaryGen02372 = 1.0;

/// Mock telemetry data representing compliance validation results.
class MockComplianceTelemetryGen02372 {
  final String stepId;
  final String metricName;
  final double complianceRate;
  final String status;
  final DateTime timestamp;

  const MockComplianceTelemetryGen02372({
    required this.stepId,
    required this.metricName,
    required this.complianceRate,
    required this.status,
    required this.timestamp,
  });

  static List<MockComplianceTelemetryGen02372> get mockData => [
        MockComplianceTelemetryGen02372(
          stepId: 'GEN-02372',
          metricName: kMetricNameGen02372,
          complianceRate: 1.0,
          status: 'Pass',
          timestamp: DateTime.now(),
        ),
      ];
}

/// A compliant button wrapper that guarantees a minimum 48x48dp touch target.
class CompliantTouchTargetButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String? tooltip;

  const CompliantTouchTargetButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: kMinTouchTargetSizeGen02372,
        minHeight: kMinTouchTargetSizeGen02372,
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: 24.0,
        icon: child,
      ),
    );
  }
}

/// A compliant slider wrapper ensuring the interactive area meets the 48x48dp minimum.
class CompliantTouchTargetSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const CompliantTouchTargetSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: kMinTouchTargetSizeGen02372,
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}

/// M3 Elevated Card displaying step completion state and compliance KPIs.
class TouchTargetComplianceCard extends StatelessWidget {
  final MockComplianceTelemetryGen02372 telemetry;

  const TouchTargetComplianceCard({
    super.key,
    required this.telemetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPassing = telemetry.complianceRate >= kFloorBoundaryGen02372;

    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      clipBehavior: Clip.antiAlias,
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
                  'Step ${telemetry.stepId}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Chip(
                  label: Text(
                    telemetry.status,
                    style: TextStyle(
                      color: isPassing
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onErrorContainer,
                    ),
                  ),
                  backgroundColor: isPassing
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.errorContainer,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              telemetry.metricName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              '${(telemetry.complianceRate * 100).toStringAsFixed(1)}%',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: isPassing
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Standards: Material Design 3, WCAG 2.2 AA, W3C Web Standards',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Drill-down link activated.'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'DISMISS',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Validation utility to check if a given Size meets the strict >= 48x48dp requirement.
class TouchTargetValidatorGen02372 {
  /// Returns true if both width and height are >= 48.0 logical pixels.
  static bool isCompliant(Size size) {
    return size.width >= kMinTouchTargetSizeGen02372 &&
        size.height >= kMinTouchTargetSizeGen02372;
  }

  /// Evaluates overall UI compliance rate from a list of sizes.
  static double calculateComplianceRate(List<Size> touchTargets) {
    if (touchTargets.isEmpty) return 0.0;
    final compliantCount =
        touchTargets.where((size) => isCompliant(size)).length;
    return compliantCount / touchTargets.length;
  }

  /// Determines Pass/Fail based on floor boundary threshold.
  static String evaluateStatus(double complianceRate) {
    return complianceRate >= kFloorBoundaryGen02372 ? 'Pass' : 'Fail';
  }
}