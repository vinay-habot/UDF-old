// GEN-02857 — Touch Target Size Enforcement Utility.
// Enforces the 48x48 dp minimum touch target size on all interactive components per WCAG 2.1 SC 2.5.5 and Material Design 3 guidelines.

import 'package:flutter/material.dart';

/// Constant representing the minimum required touch target size in logical pixels (dp).
const double kMinTouchTargetSizeGen02857 = 48.0;

/// Constant representing the floor boundary for touch target validation.
const double kFloorBoundaryTouchTargetGen02857 = 44.0;

/// Constant representing the ceiling boundary for touch target validation.
const double kCeilingBoundaryTouchTargetGen02857 = 56.0;

/// Wraps any widget to ensure it meets the minimum 48x48 dp touch target requirement.
/// Uses [ConstrainedBox] to enforce minimum dimensions without altering visual layout if the child is already larger.
class EnforcedTouchTarget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double minSize;

  const EnforcedTouchTarget({
    super.key,
    required this.child,
    this.onTap,
    this.minSize = kMinTouchTargetSizeGen02857,
  });

  @override
  Widget build(BuildContext context) {
    final Widget constrainedChild = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      child: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: constrainedChild,
      );
    }

    return constrainedChild;
  }
}

/// A wrapper that adds padding around a widget to expand its semantic and gesture hit area
/// to meet the 48x48 dp requirement, useful when visual size must remain smaller.
class TouchTargetPaddingWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const TouchTargetPaddingWrapper({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: kMinTouchTargetSizeGen02857,
            minHeight: kMinTouchTargetSizeGen02857,
          ),
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Mock data model representing a compliance check result for CI/CD or dashboard display.
class TouchTargetComplianceResult {
  final String componentId;
  final double measuredWidth;
  final double measuredHeight;
  final bool isCompliant;
  final DateTime timestamp;

  const TouchTargetComplianceResult({
    required this.componentId,
    required this.measuredWidth,
    required this.measuredHeight,
    required this.isCompliant,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'component_id': componentId,
        'measured_width_dp': measuredWidth,
        'measured_height_dp': measuredHeight,
        'is_compliant': isCompliant,
        'timestamp': timestamp.toIso8601String(),
        'standard': 'WCAG 2.1 SC 2.5.5 / M3 Touch Target Guidelines',
      };
}

/// Mock repository providing local compliance data for engineering console dashboards.
class MockTouchTargetComplianceRepository {
  static List<TouchTargetComplianceResult> fetchMockResults() {
    return [
      TouchTargetComplianceResult(
        componentId: 'btn_submit_primary',
        measuredWidth: 48.0,
        measuredHeight: 48.0,
        isCompliant: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      TouchTargetComplianceResult(
        componentId: 'icon_nav_settings',
        measuredWidth: 44.0,
        measuredHeight: 44.0,
        isCompliant: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      TouchTargetComplianceResult(
        componentId: 'chip_status_active',
        measuredWidth: 56.0,
        measuredHeight: 48.0,
        isCompliant: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ];
  }

  static bool evaluateAllCompliant(List<TouchTargetComplianceResult> results) {
    return results.every((r) => r.isCompliant);
  }
}

/// Extension on [Widget] to easily wrap any interactive element with enforced touch targets.
extension TouchTargetEnforcementExtension on Widget {
  Widget enforceMinTouchTarget({VoidCallback? onTap}) {
    return EnforcedTouchTarget(
      onTap: onTap,
      child: this,
    );
  }
}