// GEN-03187 — Spacing and Layout Grid Tokens.
// Defines 8dp baseline grid spacing tokens, layout breakpoints, and Material Design 3 grid configurations for responsive single/multi-column layouts.

import 'package:flutter/material.dart';

/// Spacing tokens based on an 8dp baseline grid (Material Design 3).
class SpacingTokens {
  SpacingTokens._();

  static const double base = 8.0;

  static const double xxs = base * 0.25; // 2dp
  static const double xs = base * 0.5; // 4dp
  static const double sm = base; // 8dp
  static const double md = base * 2; // 16dp
  static const double lg = base * 3; // 24dp
  static const double xl = base * 4; // 32dp
  static const double xxl = base * 6; // 48dp
  static const double xxxl = base * 8; // 64dp

  /// Touch target minimum size per M3 guidelines (48x48dp).
  static const double touchTargetMin = 48.0;
}

/// Layout grid configuration tokens for responsive design.
class LayoutGridTokens {
  LayoutGridTokens._();

  /// Mobile breakpoint (<600dp): Single column layout.
  static const int mobileColumns = 1;
  static const double mobileMargin = 16.0;
  static const double mobileGutter = 16.0;

  /// Tablet breakpoint (600dp - 839dp): Multi-column layout.
  static const int tabletColumns = 4;
  static const double tabletMargin = 32.0;
  static const double tabletGutter = 24.0;

  /// Desktop breakpoint (>=840dp): Multi-panel layout.
  static const int desktopColumns = 12;
  static const double desktopMargin = 64.0;
  static const double desktopGutter = 24.0;
}

/// Breakpoint thresholds matching M3 responsive layout specifications.
class LayoutBreakpoints {
  LayoutBreakpoints._();

  static const double compactMax = 599.0;
  static const double mediumMin = 600.0;
  static const double mediumMax = 839.0;
  static const double expandedMin = 840.0;
}

/// Elevation tokens for M3 Elevated Cards Level 2.
class ElevationTokens {
  ElevationTokens._();

  static const double level0 = 0.0;
  static const double level1 = 1.0;
  static const double level2 = 3.0;
  static const double level3 = 6.0;
  static const double level4 = 8.0;
  static const double level5 = 12.0;
}

/// JSON repository representation of the spacing and layout grid tokens.
/// This constant map can be serialized or used directly as a token source.
const Map<String, dynamic> layoutGridJsonRepository = {
  'version': '1.0.0',
  'standard': 'Material Design 3 Layout System',
  'baseline_grid': '8dp',
  'spacing': {
    'xxs': 2.0,
    'xs': 4.0,
    'sm': 8.0,
    'md': 16.0,
    'lg': 24.0,
    'xl': 32.0,
    'xxl': 48.0,
    'xxxl': 64.0,
    'touch_target_min': 48.0,
  },
  'layout_grid': {
    'mobile': {'columns': 1, 'margin': 16.0, 'gutter': 16.0, 'max_width': 599.0},
    'tablet': {'columns': 4, 'margin': 32.0, 'gutter': 24.0, 'min_width': 600.0, 'max_width': 839.0},
    'desktop': {'columns': 12, 'margin': 64.0, 'gutter': 24.0, 'min_width': 840.0},
  },
  'elevation': {
    'level_2_card': 3.0,
  },
  'accessibility': {
    'wcag_standard': 'WCAG 2.1 AA',
    'high_contrast_enforced': true,
    'dynamic_color_supported': true,
  }
};

/// Helper extension to apply 8dp baseline grid alignment validation.
extension BaselineGridExtension on double {
  /// Returns true if the value is a multiple of the 8dp baseline grid.
  bool get isAlignedToBaselineGrid => this % SpacingTokens.base == 0;

  /// Rounds the value to the nearest 8dp baseline grid increment.
  double snapToBaselineGrid() {
    return (this / SpacingTokens.base).round() * SpacingTokens.base;
  }
}

/// Widget that enforces layout grid constraints based on current screen width.
class ResponsiveLayoutGrid extends StatelessWidget {
  final Widget child;

  const ResponsiveLayoutGrid({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    int columns;
    double margin;
    double gutter;

    if (screenWidth <= LayoutBreakpoints.compactMax) {
      columns = LayoutGridTokens.mobileColumns;
      margin = LayoutGridTokens.mobileMargin;
      gutter = LayoutGridTokens.mobileGutter;
    } else if (screenWidth <= LayoutBreakpoints.mediumMax) {
      columns = LayoutGridTokens.tabletColumns;
      margin = LayoutGridTokens.tabletMargin;
      gutter = LayoutGridTokens.tabletGutter;
    } else {
      columns = LayoutGridTokens.desktopColumns;
      margin = LayoutGridTokens.desktopMargin;
      gutter = LayoutGridTokens.desktopGutter;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // In a full implementation, this would dynamically calculate column widths
          // based on the `columns` and `gutter` variables.
          child,
        ],
      ),
    );
  }
}