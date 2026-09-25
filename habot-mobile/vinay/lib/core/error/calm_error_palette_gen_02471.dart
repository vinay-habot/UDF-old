// GEN-02471 — Calm Error Screen Color Palette.
// Applies a calm, non-alarming color palette to error screens using Material 3 design tokens. Single-column mobile layout (<600dp) with M3 Elevated Cards and Status Chips.

import 'package:flutter/material.dart';

/// Calm, non-alarming color palette for error screens (GEN-02471).
class CalmErrorPalette {
  const CalmErrorPalette._();

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);
  static const Color primaryText = Color(0xFF212529);
  static const Color secondaryText = Color(0xFF6C757D);
  static const Color errorSoft = Color(0xFFE57373);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color onErrorContainer = Color(0xFFB71C1C);
  static const Color divider = Color(0xFFDEE2E6);
}

/// Theme extension providing the calm error palette.
class CalmErrorThemeExtension extends ThemeExtension<CalmErrorThemeExtension> {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color primaryText;
  final Color secondaryText;
  final Color errorSoft;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color divider;

  const CalmErrorThemeExtension({
    this.background = CalmErrorPalette.background,
    this.surface = CalmErrorPalette.surface,
    this.surfaceVariant = CalmErrorPalette.surfaceVariant,
    this.primaryText = CalmErrorPalette.primaryText,
    this.secondaryText = CalmErrorPalette.secondaryText,
    this.errorSoft = CalmErrorPalette.errorSoft,
    this.errorContainer = CalmErrorPalette.errorContainer,
    this.onErrorContainer = CalmErrorPalette.onErrorContainer,
    this.divider = CalmErrorPalette.divider,
  });

  @override
  ThemeExtension<CalmErrorThemeExtension> copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? primaryText,
    Color? secondaryText,
    Color? errorSoft,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? divider,
  }) {
    return CalmErrorThemeExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      errorSoft: errorSoft ?? this.errorSoft,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      divider: divider ?? this.divider,
    );
  }

  @override
  ThemeExtension<CalmErrorThemeExtension> lerp(
    covariant ThemeExtension<CalmErrorThemeExtension>? other,
    double t,
  ) {
    if (other is! CalmErrorThemeExtension) return this;
    return CalmErrorThemeExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      errorSoft: Color.lerp(errorSoft, other.errorSoft, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

/// Mock data representing an error state for the engineering console.
class ErrorStepMockData {
  final String stepId;
  final String title;
  final String status; // Complete/Partial/Not Complete
  final DateTime timestamp;
  final String traceId;

  const ErrorStepMockData({
    required this.stepId,
    required this.title,
    required this.status,
    required this.timestamp,
    required this.traceId,
  });
}

const List<ErrorStepMockData> kMockErrorSteps = [
  ErrorStepMockData(
    stepId: 'GEN-02471',
    title: 'Apply calm color palette to error screens',
    status: 'Complete',
    timestamp: DateTime(2026, 9, 25, 10, 30),
    traceId: 'trace-abc-123',
  ),
  ErrorStepMockData(
    stepId: 'GEN-02470',
    title: 'Foundational error configuration',
    status: 'Partial',
    timestamp: DateTime(2026, 9, 25, 10, 25),
    traceId: 'trace-def-456',
  ),
];

/// A reusable widget that displays an error screen using the calm palette.
/// Follows M3 responsive layout: single-column on mobile (<600dp).
class CalmErrorScreen extends StatelessWidget {
  final String errorMessage;
  final List<ErrorStepMockData> steps;

  const CalmErrorScreen({
    super.key,
    this.errorMessage = 'An unexpected issue occurred. Our team has been notified.',
    this.steps = kMockErrorSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<CalmErrorThemeExtension>() ?? const CalmErrorThemeExtension();

    return Scaffold(
      backgroundColor: ext.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final content = _buildContent(context, ext, isMobile);
            
            if (isMobile) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: content,
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 840),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: content,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CalmErrorThemeExtension ext, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderCard(context, ext),
        const SizedBox(height: 16),
        Text(
          'Process Completion Rate',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ext.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        ...steps.map((step) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildStepCard(context, ext, step),
        )),
      ],
    );
  }

  /// M3 Elevated Card Level 2 (3dp elevation) for the main error message.
  Widget _buildHeaderCard(BuildContext context, CalmErrorThemeExtension ext) {
    return Card(
      elevation: 3.0,
      color: ext.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 48,
              color: ext.errorSoft,
            ),
            const SizedBox(height: 16),
            Text(
              'System Notice',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ext.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: ext.secondaryText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// M3 Status Card displaying step completion state with inline status chip.
  Widget _buildStepCard(BuildContext context, CalmErrorThemeExtension ext, ErrorStepMockData step) {
    final isComplete = step.status == 'Complete';
    final chipColor = isComplete ? Colors.green.shade50 : ext.errorContainer;
    final chipTextColor = isComplete ? Colors.green.shade800 : ext.onErrorContainer;

    return Card(
      elevation: 1.0,
      color: ext.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ext.divider, width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Deep-link drill-down placeholder
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Drill-down for ${step.traceId}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ext.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${step.stepId} • ${step.timestamp.toIso8601String().substring(0, 16)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: ext.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // M3 Status Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  step.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: chipTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
