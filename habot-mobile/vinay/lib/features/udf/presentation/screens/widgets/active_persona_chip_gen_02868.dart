// GEN-02868 — Active Persona Indicator Chip.
// Displays a collapsible Material 3 indicator chip at the top of the mobile chat panel with 48x48dp touch targets, dynamic color, and mock persona data.

import 'package:flutter/material.dart';

/// Mock data representing the active persona state.
class _MockPersonaData {
  final String id;
  final String name;
  final String role;
  final Color avatarColor;

  const _MockPersonaData({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarColor,
  });
}

const List<_MockPersonaData> _kMockPersonas = [
  _MockPersonaData(
    id: 'persona_001',
    name: 'Engineering Lead',
    role: 'Architecture & Implementation Governance',
    avatarColor: Colors.blue,
  ),
  _MockPersonaData(
    id: 'persona_002',
    name: 'UX Designer',
    role: 'Mobile-First Design',
    avatarColor: Colors.purple,
  ),
];

/// A collapsible Active Persona indicator chip adhering to M3 guidelines.
///
/// Features:
/// - Single-column mobile layout (<600dp) / multi-column desktop (>=840dp)
/// - 48x48dp minimum touch targets
/// - Material You dynamic color support via [ColorScheme]
/// - Collapsible animation for detail expansion
class ActivePersonaIndicatorChip extends StatefulWidget {
  const ActivePersonaIndicatorChip({super.key});

  @override
  State<ActivePersonaIndicatorChip> createState() =>
      _ActivePersonaIndicatorChipState();
}

class _ActivePersonaIndicatorChipState
    extends State<ActivePersonaIndicatorChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _isExpanded = false;

  // Mock active persona selection
  _MockPersonaData _activePersona = _kMockPersonas.first;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _selectPersona(_MockPersonaData persona) {
    setState(() {
      _activePersona = persona;
      _isExpanded = false;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Semantics(
      label: 'Active Persona Indicator',
      hint: 'Tap to expand or collapse persona details',
      button: true,
      child: Material(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        elevation: 2.0, // M3 Elevated Card Level 2 approximation (3dp shadow)
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: _toggleExpansion,
          borderRadius: BorderRadius.circular(16.0),
          // Enforce 48x48dp minimum touch target
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 48.0,
              minWidth: 48.0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collapsed Header Row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16.0,
                        backgroundColor: _activePersona.avatarColor,
                        child: Text(
                          _activePersona.name.isNotEmpty
                              ? _activePersona.name[0].toUpperCase()
                              : '?',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Active Persona',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              _activePersona.name,
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // M3 Status Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Active',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      RotationTransition(
                        turns: Tween<double>(begin: 0.0, end: 0.5)
                            .animate(_expandAnimation),
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: colorScheme.onSurfaceVariant,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                  // Expandable Details Section
                  SizeTransition(
                    sizeFactor: _expandAnimation,
                    axisAlignment: -1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: colorScheme.outlineVariant,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'Role: ${_activePersona.role}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'Switch Persona:',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: _kMockPersonas.map((persona) {
                              final bool isSelected =
                                  persona.id == _activePersona.id;
                              return FilterChip(
                                label: Text(persona.name),
                                selected: isSelected,
                                onSelected: (_) => _selectPersona(persona),
                                avatar: CircleAvatar(
                                  radius: 12.0,
                                  backgroundColor: persona.avatarColor,
                                  child: Text(
                                    persona.name[0].toUpperCase(),
                                    style: const TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                // Ensure 48x48dp touch target compliance
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
                                ),
                                selectedColor:
                                    colorScheme.secondaryContainer,
                                checkmarkColor:
                                    colorScheme.onSecondaryContainer,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Responsive wrapper that enforces single-column on mobile (<600dp)
/// and adapts layout width on desktop (>=840dp).
class ResponsivePersonaChipWrapper extends StatelessWidget {
  const ResponsivePersonaChipWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // M3 responsive layout: single-column on mobile (<600dp),
        // constrained width on tablet/desktop (>=840dp)
        if (screenWidth >= 840.0) {
          return Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: const ActivePersonaIndicatorChip(),
            ),
          );
        }

        // Mobile / Tablet single-column full width
        return const ActivePersonaIndicatorChip();
      },
    );
  }
}
