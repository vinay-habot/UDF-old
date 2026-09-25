// GEN-02494 — Scoring API Irregular Access Monitor Card.
// M3 Elevated Card displaying real-time status of scoring API access monitoring, flagging irregular accounts with background polling and pull-to-refresh support.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data model representing the state of the scoring API monitor step.
class ApiMonitorState {
  final String stepId;
  final String description;
  final String completionStatus; // 'Complete', 'Partial', 'Not Complete'
  final double processCompletionRate;
  final DateTime lastChecked;
  final bool isFlagged;

  const ApiMonitorState({
    required this.stepId,
    required this.description,
    required this.completionStatus,
    required this.processCompletionRate,
    required this.lastChecked,
    required this.isFlagged,
  });
}

/// Mock repository providing local data for the scoring API monitor.
class MockScoringApiRepository {
  static const List<ApiMonitorState> _mockStates = [
    ApiMonitorState(
      stepId: 'GEN-02494',
      description: 'Automatically flag accounts attempting irregular access to the scoring APIs (Self-Chasing).',
      completionStatus: 'Complete',
      processCompletionRate: 1.0,
      lastChecked: null as dynamic,
      isFlagged: false,
    ),
  ];

  Future<ApiMonitorState> fetchMonitorState() async {
    await Future.delayed(const Duration(milliseconds: 80)); // Sub-100ms simulation
    final now = DateTime.now();
    return ApiMonitorState(
      stepId: _mockStates[0].stepId,
      description: _mockStates[0].description,
      completionStatus: _mockStates[0].completionStatus,
      processCompletionRate: _mockStates[0].processCompletionRate,
      lastChecked: now,
      isFlagged: _mockStates[0].isFlagged,
    );
  }
}

/// M3 Elevated Card widget for the engineering console dashboard.
/// Implements single-column mobile layout (<600dp) and multi-column desktop (>=840dp).
/// Features 30-second background polling and pull-to-refresh.
class ScoringApiMonitorCard extends StatefulWidget {
  const ScoringApiMonitorCard({super.key});

  @override
  State<ScoringApiMonitorCard> createState() => _ScoringApiMonitorCardState();
}

class _ScoringApiMonitorCardState extends State<ScoringApiMonitorCard> {
  final MockScoringApiRepository _repository = MockScoringApiRepository();
  ApiMonitorState? _state;
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Background polling refreshes data every 30 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) _loadData(showLoading: false);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData({bool showLoading = true}) async {
    if (showLoading) setState(() => _isLoading = true);
    try {
      final newState = await _repository.fetchMonitorState();
      if (mounted) {
        setState(() {
          _state = newState;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'Complete':
        return colorScheme.primary;
      case 'Partial':
        return colorScheme.tertiary;
      case 'Not Complete':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: () => _loadData(showLoading: false),
      color: colorScheme.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (>=840dp)
          final bool isDesktop = constraints.maxWidth >= 840;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _isLoading && _state == null
                    ? const Center(child: CircularProgressIndicator())
                    : _state == null
                        ? Center(
                            child: Text('No data available', style: textTheme.bodyLarge),
                          )
                        : isDesktop
                            ? _buildDesktopLayout(context, _state!, textTheme, colorScheme)
                            : _buildMobileLayout(context, _state!, textTheme, colorScheme),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    ApiMonitorState state,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context, state, textTheme, colorScheme),
        const SizedBox(height: 16),
        _buildMetrics(state, textTheme, colorScheme),
        const SizedBox(height: 16),
        _buildDescription(state, textTheme),
        const SizedBox(height: 24),
        _buildDeepLinkButton(context, state, colorScheme),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    ApiMonitorState state,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, state, textTheme, colorScheme),
              const SizedBox(height: 16),
              _buildDescription(state, textTheme),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildMetrics(state, textTheme, colorScheme),
              const SizedBox(height: 24),
              _buildDeepLinkButton(context, state, colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ApiMonitorState state,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Step ${state.stepId}: API Monitor',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        // M3 Status Chips for health indicators
        Chip(
          avatar: Icon(
            state.isFlagged ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            size: 18,
            color: state.isFlagged ? colorScheme.error : colorScheme.primary,
          ),
          label: Text(
            state.isFlagged ? 'Irregular Access Flagged' : 'Nominal',
            style: textTheme.labelMedium?.copyWith(
              color: state.isFlagged ? colorScheme.error : colorScheme.onSurfaceVariant,
            ),
          ),
          backgroundColor: state.isFlagged
              ? colorScheme.errorContainer.withOpacity(0.3)
              : colorScheme.surfaceContainerHighest.withOpacity(0.3),
          side: BorderSide.none,
        ),
      ],
    );
  }

  Widget _buildMetrics(
    ApiMonitorState state,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        _buildMetricItem(
          'Process Completion Rate',
          '${(state.processCompletionRate * 100).toStringAsFixed(0)}%',
          textTheme,
          colorScheme,
        ),
        _buildMetricItem(
          'Status',
          state.completionStatus,
          textTheme,
          colorScheme,
          valueColor: _getStatusColor(colorScheme, state.completionStatus),
        ),
        _buildMetricItem(
          'Last Checked',
          state.lastChecked != null
              ? '${state.lastChecked!.hour.toString().padLeft(2, '0')}:${state.lastChecked!.minute.toString().padLeft(2, '0')}:${state.lastChecked!.second.toString().padLeft(2, '0')}'
              : 'N/A',
          textTheme,
          colorScheme,
        ),
      ],
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    TextTheme textTheme,
    ColorScheme colorScheme, {
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: textTheme.labelSmall?.copyWith(color: colorScheme.outline)),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ApiMonitorState state, TextTheme textTheme) {
    return Text(
      state.description,
      style: textTheme.bodyMedium,
    );
  }

  Widget _buildDeepLinkButton(
    BuildContext context,
    ApiMonitorState state,
    ColorScheme colorScheme,
  ) {
    // 48x48dp touch targets
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          // Deep-link drill-down action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Drilling down into ${state.stepId} details...'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.open_in_new, size: 20),
        label: const Text('View Details'),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}
