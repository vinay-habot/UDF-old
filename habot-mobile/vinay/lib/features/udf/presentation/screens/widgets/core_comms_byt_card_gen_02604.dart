// GEN-02604 — Core Communications Library Byt Status Card.
// Displays the process completion rate for storing the Byt in the Core Communications Library using M3 ElevatedCard, status chips, 30s polling, and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum ProcessCompletionState { complete, partial, notComplete }

class CoreCommsBytMockData {
  static const String stepName = 'Store the Byt in the Core Communications Library';
  static const String atomicId = 'GEN-02604';
  static const String globalRefId = 'GEN-02604';
  static const String dependency = 'GEN-02603';
  static const String standardSpec = 'ISO/IEC 25010 (Product Quality)';
  static const double optimalTargetMin = 0.95;
  static const double optimalTargetMax = 1.0;
  static const int pollIntervalSeconds = 30;

  static ProcessCompletionState currentState = ProcessCompletionState.complete;
  static double currentRate = 0.98;
  static DateTime lastUpdated = DateTime.now();
}

class CoreCommsBytCard extends StatefulWidget {
  const CoreCommsBytCard({super.key});

  @override
  State<CoreCommsBytCard> createState() => _CoreCommsBytCardState();
}

class _CoreCommsBytCardState extends State<CoreCommsBytCard> {
  Timer? _pollingTimer;
  late double _completionRate;
  late ProcessCompletionState _state;
  late DateTime _lastUpdated;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _loadMockData() {
    setState(() {
      _completionRate = CoreCommsBytMockData.currentRate;
      _state = CoreCommsBytMockData.currentState;
      _lastUpdated = CoreCommsBytMockData.lastUpdated;
    });
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(
      const Duration(seconds: CoreCommsBytMockData.pollIntervalSeconds),
      (_) => _simulatePollingRefresh(),
    );
  }

  Future<void> _simulatePollingRefresh() async {
    if (!mounted || _isRefreshing) return;
    setState(() => _isRefreshing = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // Simulate slight data variation for mock realism
    final newRate = (CoreCommsBytMockData.currentRate + (DateTime.now().millisecond % 3 - 1) * 0.01).clamp(0.0, 1.0);
    final newState = newRate >= 0.95
        ? ProcessCompletionState.complete
        : newRate > 0.0
            ? ProcessCompletionState.partial
            : ProcessCompletionState.notComplete;

    setState(() {
      _completionRate = newRate;
      _state = newState;
      _lastUpdated = DateTime.now();
      _isRefreshing = false;
    });
  }

  Future<void> _onManualRefresh() async {
    await _simulatePollingRefresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data synced successfully.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Color _getStatusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (_state) {
      case ProcessCompletionState.complete:
        return colorScheme.primary;
      case ProcessCompletionState.partial:
        return colorScheme.tertiary;
      case ProcessCompletionState.notComplete:
        return colorScheme.error;
    }
  }

  String _getStateLabel() {
    switch (_state) {
      case ProcessCompletionState.complete:
        return 'Complete';
      case ProcessCompletionState.partial:
        return 'Partial';
      case ProcessCompletionState.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return RefreshIndicator(
      onRefresh: _onManualRefresh,
      color: colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Engineering Console',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: isMobile
                      ? _buildSingleColumnLayout(theme)
                      : _buildMultiColumnLayout(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleColumnLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderRow(theme),
        const SizedBox(height: 24),
        _buildMetricSection(theme),
        const SizedBox(height: 24),
        _buildMetadataSection(theme),
        const SizedBox(height: 16),
        _buildFooterRow(theme),
      ],
    );
  }

  Widget _buildMultiColumnLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderRow(theme),
              const SizedBox(height: 24),
              _buildMetricSection(theme),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMetadataSection(theme),
              const SizedBox(height: 24),
              _buildFooterRow(theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            CoreCommsBytMockData.stepName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Chip(
          avatar: Icon(
            _state == ProcessCompletionState.complete
                ? Icons.check_circle
                : _state == ProcessCompletionState.partial
                    ? Icons.pending
                    : Icons.error_outline,
            size: 18,
            color: _getStatusColor(context),
          ),
          label: Text(
            _getStateLabel(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: _getStatusColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: _getStatusColor(context).withValues(alpha: 0.12),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      ],
    );
  }

  Widget _buildMetricSection(ThemeData theme) {
    final percentage = (_completionRate * 100).toStringAsFixed(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Process Completion Rate',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$percentage%',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getStatusColor(context),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Target: 95-100%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: _completionRate,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(context)),
        ),
      ],
    );
  }

  Widget _buildMetadataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaTile(
          theme,
          icon: Icons.tag,
          label: 'Atomic ID',
          value: CoreCommsBytMockData.atomicId,
        ),
        const SizedBox(height: 12),
        _buildMetaTile(
          theme,
          icon: Icons.account_tree_outlined,
          label: 'Dependency',
          value: CoreCommsBytMockData.dependency,
        ),
        const SizedBox(height: 12),
        _buildMetaTile(
          theme,
          icon: Icons.verified_outlined,
          label: 'Standard',
          value: CoreCommsBytMockData.standardSpec,
        ),
      ],
    );
  }

  Widget _buildMetaTile(ThemeData theme, {required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Last updated: ${_formatTime(_lastUpdated)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (_isRefreshing)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          )
        else
          InkWell(
            onTap: _onManualRefresh,
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 48,
              height: 48, // 48x48dp touch targets
              child: Center(
                child: Icon(
                  Icons.refresh,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}