// GEN-03176 — Certification Icon Widget.
// Renders a Material Check Circle/Verified icon at 48x48 dp for mobile certification status, adhering to WCAG 2.1 SC 2.5.5 touch target guidelines and M3 standards.

import 'package:flutter/material.dart';

/// A reusable widget that displays the certification status using a Material 3
/// Verified icon at exactly 48x48 logical pixels (dp).
///
/// Ensures minimum touch target size compliance (floor: 44.0 dp, optimal: 48.0 dp).
class CertificationIcon extends StatelessWidget {
  const CertificationIcon({
    super.key,
    this.isCertified = true,
    this.color,
    this.onTap,
  });

  /// Whether the entity is certified. Defaults to true.
  final bool isCertified;

  /// Optional color override. Falls back to [ColorScheme.primary] if null.
  final Color? color;

  /// Optional tap callback for interaction.
  final VoidCallback? onTap;

  // Metric constants per requirement GEN-03176
  static const double _iconSize = 48.0;
  static const double _minTouchTargetFloor = 44.0;

  @override
  Widget build(BuildContext context) {
    assert(
      _iconSize >= _minTouchTargetFloor,
      'Icon size must meet or exceed the minimum touch target floor of $_minTouchTargetFloor dp.',
    );

    final theme = Theme.of(context);
    final resolvedColor = color ?? theme.colorScheme.primary;

    final iconWidget = Icon(
      Icons.verified_rounded,
      size: _iconSize,
      color: isCertified ? resolvedColor : theme.colorScheme.outlineVariant,
      semanticLabel: isCertified ? 'Certified' : 'Not Certified',
    );

    if (onTap != null) {
      return Semantics(
        button: true,
        label: isCertified ? 'Certified' : 'Not Certified',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_iconSize / 2),
          child: SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: Center(child: iconWidget),
          ),
        ),
      );
    }

    return Semantics(
      label: isCertified ? 'Certified' : 'Not Certified',
      child: SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: Center(child: iconWidget),
      ),
    );
  }
}

/// Mock data provider for local development and testing without backend dependency.
class CertificationMockData {
  const CertificationMockData._();

  static const List<Map<String, dynamic>> mockCertifications = [
    {'id': 'cert_001', 'name': 'ISO 9001', 'isCertified': true},
    {'id': 'cert_002', 'name': 'SOC 2 Type II', 'isCertified': true},
    {'id': 'cert_003', 'name': 'GDPR Compliance', 'isCertified': false},
  ];

  static bool getPassFailStatus(double actualSize) {
    return actualSize >= CertificationIcon._minTouchTargetFloor;
  }
}
