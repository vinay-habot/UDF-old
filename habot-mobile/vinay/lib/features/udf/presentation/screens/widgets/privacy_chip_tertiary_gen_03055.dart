// GEN-03055 — Privacy Chip with Tertiary Container Styling and Lock Icon.
// Applies Material Design 3 Tertiary Container styling with a lock icon to all privacy chips on mobile. Enforces 48x48dp touch targets and dynamic color support.

import 'package:flutter/material.dart';

/// Reusable privacy chip widget styled with M3 Tertiary Container colors
/// and a leading lock icon, optimized for mobile-first layouts.
class PrivacyChipTertiaryGen03055 extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  const PrivacyChipTertiaryGen03055({
    super.key,
    required this.label,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Privacy setting: $label',
      child: SizedBox(
        height: 48.0,
        child: FilterChip(
          selected: isSelected,
          showCheckmark: false,
          avatar: Icon(
            Icons.lock_rounded,
            size: 18.0,
            color: isSelected
                ? colorScheme.onTertiaryContainer
                : colorScheme.onSurfaceVariant,
          ),
          label: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? colorScheme.onTertiaryContainer
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: colorScheme.surface,
          selectedColor: colorScheme.tertiaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: isSelected
                  ? colorScheme.tertiaryContainer
                  : colorScheme.outlineVariant,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onSelected: onTap != null ? (_) => onTap!() : null,
        ),
      ),
    );
  }
}

/// Mock data representing privacy settings for local development
/// without requiring backend API integration.
class PrivacyChipMockDataSourceGen03055 {
  static const List<Map<String, dynamic>> mockPrivacySettings = [
    {'id': 'priv_001', 'label': 'Profile Visibility', 'isSelected': true},
    {'id': 'priv_002', 'label': 'Data Sharing', 'isSelected': false},
    {'id': 'priv_003', 'label': 'Location Tracking', 'isSelected': false},
    {'id': 'priv_004', 'label': 'Analytics Opt-in', 'isSelected': true},
    {'id': 'priv_005', 'label': 'Third-party Access', 'isSelected': false},
  ];
}

/// Preview wrapper demonstrating the privacy chips in an M3 Elevated Card
/// with single-column mobile layout (<600dp).
class PrivacyChipsPreviewCardGen03055 extends StatefulWidget {
  const PrivacyChipsPreviewCardGen03055({super.key});

  @override
  State<PrivacyChipsPreviewCardGen03055> createState() =>
      _PrivacyChipsPreviewCardGen03055State();
}

class _PrivacyChipsPreviewCardGen03055State
    extends State<PrivacyChipsPreviewCardGen03055> {
  late List<bool> _selectionStates;

  @override
  void initState() {
    super.initState();
    _selectionStates = PrivacyChipMockDataSourceGen03055.mockPrivacySettings
        .map((e) => e['isSelected'] as bool)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final items = PrivacyChipMockDataSourceGen03055.mockPrivacySettings;

    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8.0),
                Text(
                  'Privacy Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(items.length, (index) {
                return PrivacyChipTertiaryGen03055(
                  label: items[index]['label'] as String,
                  isSelected: _selectionStates[index],
                  onTap: () {
                    setState(() {
                      _selectionStates[index] = !_selectionStates[index];
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
