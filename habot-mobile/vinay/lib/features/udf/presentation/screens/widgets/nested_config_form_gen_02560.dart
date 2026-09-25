// GEN-02560 — Nested Configuration Form with M3 Elevated Cards and Status Chips.
// Implements deeply nested configuration forms for mobile engineering console with responsive layout, background polling, and mock telemetry data.

import 'dart:async';
import 'package:flutter/material.dart';

enum StepHealth { good, average, poor }

class MockTelemetryEvent {
  final String traceId;
  final DateTime timestamp;
  final double latencyMs;
  final StepHealth health;

  const MockTelemetryEvent({
    required this.traceId,
    required this.timestamp,
    required this.latencyMs,
    required this.health,
  });
}

class MockConfigRepository {
  static const List<MockTelemetryEvent> events = [
    MockTelemetryEvent(traceId: 'trace-001', timestamp: _kNow, latencyMs: 45.2, health: StepHealth.good),
    MockTelemetryEvent(traceId: 'trace-002', timestamp: _kNow, latencyMs: 180.5, health: StepHealth.average),
    MockTelemetryEvent(traceId: 'trace-003', timestamp: _kNow, latencyMs: 410.0, health: StepHealth.poor),
    MockTelemetryEvent(traceId: 'trace-004', timestamp: _kNow, latencyMs: 88.1, health: StepHealth.good),
  ];
  static const DateTime _kNow = DateTime(2026, 9, 25, 12, 0);

  Future<List<MockTelemetryEvent>> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return events;
  }
}

class NestedConfigFormGen02560 extends StatefulWidget {
  const NestedConfigFormGen02560({super.key});

  @override
  State<NestedConfigFormGen02560> createState() => _NestedConfigFormGen02560State();
}

class _NestedConfigFormGen02560State extends State<NestedConfigFormGen02560> {
  final MockConfigRepository _repository = MockConfigRepository();
  List<MockTelemetryEvent> _events = [];
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
    final data = await _repository.fetchEvents();
    if (!mounted) return;
    setState(() {
      _events = data;
      _isLoading = false;
    });
  }

  Color _healthColor(StepHealth health, ColorScheme cs) {
    switch (health) {
      case StepHealth.good:
        return cs.primary;
      case StepHealth.average:
        return cs.tertiary;
      case StepHealth.poor:
        return cs.error;
    }
  }

  String _healthLabel(StepHealth health) {
    switch (health) {
      case StepHealth.good:
        return 'Good';
      case StepHealth.average:
        return 'Average';
      case StepHealth.poor:
        return 'Poor';
    }
  }

  void _openConfigBottomSheet(MockTelemetryEvent event) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configuration Input', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Trace ID',
                  border: const OutlineInputBorder(),
                  hintText: event.traceId,
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Latency Threshold Override (ms)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration saved successfully.')),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console'),
        centerTitle: false,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final crossAxisCount = isMobile ? 1 : (constraints.maxWidth >= 840 ? 3 : 2);

            if (_isLoading && _events.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isMobile ? 2.5 : 2.0,
              ),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () => _openConfigBottomSheet(event),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  event.traceId,
                                  style: textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  _healthLabel(event.health),
                                  style: TextStyle(
                                    color: _healthColor(event.health, colorScheme),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: _healthColor(event.health, colorScheme).withOpacity(0.12),
                                side: BorderSide.none,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('API Response Latency', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${event.latencyMs.toStringAsFixed(1)} ms',
                                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.settings_outlined,
                                size: 24,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}