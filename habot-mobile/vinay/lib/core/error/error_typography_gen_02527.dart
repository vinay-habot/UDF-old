// GEN-02527 — Consistent Error Typography Enforcement.
// Defines standardized M3 error text styles and a reusable ErrorText widget for consistent error display across the application.

import 'package:flutter/material.dart';

/// Enforces consistent error typography across the application using Material 3 standards.
class ErrorTypographyGen02527 {
  ErrorTypographyGen02527._();

  /// Standard error headline style (e.g., for full-screen error states).
  static TextStyle headlineError(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.error,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    );
  }

  /// Standard error body style (e.g., for inline form errors or descriptions).
  static TextStyle bodyError(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.error,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    );
  }

  /// Standard error label style (e.g., for small badges or chips).
  static TextStyle labelError(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.labelLarge!.copyWith(
      color: theme.colorScheme.error,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    );
  }
}

/// Reusable widget that applies enforced error typography.
/// Ensures 48x48dp minimum touch targets when interactive, per M3 guidelines.
class ErrorText extends StatelessWidget {
  final String message;
  final ErrorTextVariant variant;
  final VoidCallback? onTap;

  const ErrorText({
    super.key,
    required this.message,
    this.variant = ErrorTextVariant.body,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = switch (variant) {
      ErrorTextVariant.headline => ErrorTypographyGen02527.headlineError(context),
      ErrorTextVariant.body => ErrorTypographyGen02527.bodyError(context),
      ErrorTextVariant.label => ErrorTypographyGen02527.labelError(context),
    };

    final textWidget = Text(
      message,
      style: textStyle,
      textAlign: TextAlign.start,
      semanticsLabel: 'Error: $message',
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 48.0,
            minHeight: 48.0,
          ),
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: textWidget,
            ),
          ),
        ),
      );
    }

    return textWidget;
  }
}

enum ErrorTextVariant {
  headline,
  body,
  label,
}

/// Mock data for engineering console KPI cards related to error typography compliance.
class ErrorTypographyMockData {
  static const Map<String, dynamic> complianceStatus = {
    'step_id': 'GEN-02527',
    'metric_name': 'Process Completion Rate',
    'completion_status': 'Complete',
    'floor_boundary': 0,
    'optimal_target': '95-100%',
    'ceiling_boundary': 1,
    'iso_standard': 'ISO/IEC 25010',
    'last_validated_timestamp': '2026-09-25T10:00:00Z',
    'ci_cd_pass_rate': '100%',
  };
}