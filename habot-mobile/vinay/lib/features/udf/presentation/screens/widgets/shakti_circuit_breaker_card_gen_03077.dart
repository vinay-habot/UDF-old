// GEN-03077 — Shakti Circuit Breaker Status Card.
// Displays MTTR metric and step completion state using M3 Elevated Card with inline status chip. Single-column mobile layout (<600dp), multi-column desktop (>=840dp). 48x48dp touch targets. Background polling every 30s, pull-to-refresh manual sync.

import 'dart:async';
import 'package:flutter/material.dart';

enum StepStatus { pass, fail, pending }

class ShaktiCircuitBreakerModel {
  final String atomicId;
  final String stepName;
  final double mttrMinutes;
  final StepStatus status;
  final DateTime lastUpdated;

  const ShaktiCircuitBreakerModel({
    required this.atomicId,
    required this.stepName,
    required this.mttrMinutes,
    required this.status,
    required this.lastUpdated,
  });
}

class MockShaktiRepository {
  static const ShaktiCircuitBreakerModel mockData = ShaktiCircuitBreakerModel(
    atomicId: 'GEN-03077',
    stepName: 'Store the Shakti circuit breaker in services/incidents/shakti_circuit_breaker.py',
    mttrMinutes: 12.5,
    status: StepStatus.pass,
    lastUpdated: null,
  );

  Future<ShaktiCircuitBreakerModel> fetchStatus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ShaktiCircuitBreakerModel(
      atomicId: mockData.atomicId,
      stepName: mockData.stepName,
      mttrMinutes: mockData.mttrMinutes,
      status: mockData.status,
      lastUpdated: DateTime.now(),
    );
  }
}

class ShaktiCircuitBreakerCard extends StatefulWidget {
  const ShaktiCircuitBreakerCard({super.key});

  @override
  State<ShaktiCircuitBreakerCard> createState() => _ShaktiCircuitBreakerCardState();
}

class _ShaktiCircuitBreakerCardState extends State<ShaktiCircuitBreakerCard> {
  final MockShaktiRepository _repository = MockShaktiRepository();
  ShaktiCircuitBreakerModel? _model;
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadData());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final data = await _repository.fetchStatus();
      if (mounted) setState(() { _model = data; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _statusColor(BuildContext context, StepStatus status) {
    final cs = Theme.of(context).colorScheme;
    switch (status) {
      case StepStatus.pass: return cs.primary;
      case StepStatus.fail: return cs.error;
      case StepStatus.pending: return cs.tertiary;
    }
  }

  String _statusLabel(StepStatus status) {
    switch (status) {
      case StepStatus.pass: return 'Pass';
      case StepStatus.fail: return 'Fail';
      case StepStatus.pending: return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading && _model == null
              ? const Center(child: CircularProgressIndicator())
              : _buildCard(theme, cs, isMobile),
        ),
      ),
    );
  }

  Widget _buildCard(ThemeData theme, ColorScheme cs, bool isMobile) {
    final model = _model!;
    final optimalTarget = 15.0;
    final floorBoundary = 60.0;
    final ceilingBoundary = 120.0;

    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    model.atomicId,
                    style: theme.textUtility.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Semantics(
                  label: 'Status: ${_statusLabel(model.status)}',
                  child: Chip(
                    avatar: Icon(Icons.circle, size: 12, color: _statusColor(context, model.status)),
                    label: Text(_statusLabel(model.status)),
                    backgroundColor: _statusColor(context, model.status).withOpacity(0.12),
                    labelStyle: TextStyle(color: _statusColor(context, model.status)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              model.stepName,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (isMobile)
              _buildMetricsColumn(theme, cs, model, optimalTarget, floorBoundary, ceilingBoundary)
            else
              _buildMetricsRow(theme, cs, model, optimalTarget, floorBoundary, ceilingBoundary),
            const SizedBox(height: 16),
            if (model.lastUpdated != null)
              Text(
                'Last updated: ${model.lastUpdated!.toLocal().toString().split('.').first}',
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 48,
                width: 48,
                child: IconButton(
                  icon: const Icon(Icons.open_in_new),
                  tooltip: 'Drill down',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Deep-link drill-down triggered'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(label: 'OK', onPressed: () {}),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsColumn(ThemeData theme, ColorScheme cs, ShaktiCircuitBreakerModel model, double optimal, double floor, double ceiling) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metricTile(theme, 'MTTR (min)', '${model.mttrMinutes}'),
        _metricTile(theme, 'Optimal Target', '$optimal'),
        _metricTile(theme, 'Floor Boundary', '$floor'),
        _metricTile(theme, 'Ceiling Boundary', '$ceiling'),
        _metricTile(theme, 'Standard', 'ITIL v4 Incident Management Practice'),
      ],
    );
  }

  Widget _buildMetricsRow(ThemeData theme, ColorScheme cs, ShaktiCircuitBreakerModel model, double optimal, double floor, double ceiling) {
    return Row(
      children: [
        Expanded(child: _metricTile(theme, 'MTTR (min)', '${model.mttrMinutes}')),
        Expanded(child: _metricTile(theme, 'Optimal Target', '$optimal')),
        Expanded(child: _metricTile(theme, 'Floor Boundary', '$floor')),
        Expanded(child: _metricTile(theme, 'Ceiling Boundary', '$ceiling')),
        Expanded(child: _metricTile(theme, 'Standard', 'ITIL v4')),
      ],
    );
  }

  Widget _metricTile(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
