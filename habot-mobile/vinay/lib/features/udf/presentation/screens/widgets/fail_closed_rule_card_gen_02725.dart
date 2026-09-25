// GEN-02725 — Fail Closed Rule Configuration Card for Engineering Console.
// Displays offline data submission block status using M3 Elevated Cards, Status Chips, and responsive layout with mock telemetry data.

import 'package:flutter/material.dart';

enum ConfigurationStatus { complete, partial, notComplete }

class FailClosedRuleMockData {
  final String stepId;
  final String ruleName;
  final ConfigurationStatus status;
  final DateTime lastValidated;
  final double completenessRate;

  const FailClosedRuleMockData({
    required this.stepId,
    required this.ruleName,
    required this.status,
    required this.lastValidated,
    required this.completenessRate,
  });
}

const List<FailClosedRuleMockData> _mockRules = [
  FailClosedRuleMockData(
    stepId: 'GEN-02725',
    ruleName: 'Block Data Submission (Offline)',
    status: ConfigurationStatus.complete,
    lastValidated: DateTime(2026, 9, 25, 10, 30),
    completenessRate: 1.0,
  ),
  FailClosedRuleMockData(
    stepId: 'GEN-02725-B',
    ruleName: 'Engineering Console Sync Gate',
    status: ConfigurationStatus.partial,
    lastValidated: DateTime(2026, 9, 25, 10, 28),
    completenessRate: 0.65,
  ),
];

class FailClosedRuleCardGen02725 extends StatefulWidget {
  const FailClosedRuleCardGen02725({super.key});

  @override
  State<FailClosedRuleCardGen02725> createState() => _FailClosedRuleCardGen02725State();
}

class _FailClosedRuleCardGen02725State extends State<FailClosedRuleCardGen02725> {
  late List<FailClosedRuleMockData> _rules;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _rules = List.from(_mockRules);
  }

  Future<void> _simulatePullToRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _rules = List.from(_mockRules);
        _isRefreshing = false;
      });
    }
  }

  Color _statusColor(BuildContext context, ConfigurationStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case ConfigurationStatus.complete:
        return colorScheme.primary;
      case ConfigurationStatus.partial:
        return colorScheme.tertiary;
      case ConfigurationStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _statusLabel(ConfigurationStatus status) {
    switch (status) {
      case ConfigurationStatus.complete:
        return 'Complete';
      case ConfigurationStatus.partial:
        return 'Partial';
      case ConfigurationStatus.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return RefreshIndicator(
      onRefresh: _simulatePullToRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isDesktop) {
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.4,
              ),
              itemCount: _rules.length,
              itemBuilder: (context, index) => _buildCard(context, _rules[index]),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: _rules.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) => _buildCard(context, _rules[index]),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, FailClosedRuleMockData rule) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(context, rule.status);

    return Card(
      elevation: 3.0, // M3 Elevated Card Level 2 (3dp)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showConfigBottomSheet(context, rule),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      rule.ruleName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Chip(
                    label: Text(
                      _statusLabel(rule.status),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: statusColor,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                'Step ID: ${rule.stepId}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Completeness Rate: ${(rule.completenessRate * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Last Validated: ${rule.lastValidated.toLocal().toString().substring(0, 16)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => _showConfigBottomSheet(context, rule),
                  child: const Text('Configure'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfigBottomSheet(BuildContext context, FailClosedRuleMockData rule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24.0,
            right: 24.0,
            top: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Configure: ${rule.ruleName}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Fail Closed rule blocks all data submission actions while the system is in the offline state.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24.0),
              SwitchListTile(
                title: const Text('Enable Offline Block'),
                subtitle: const Text('Prevents data submission when disconnected'),
                value: rule.status == ConfigurationStatus.complete || rule.status == ConfigurationStatus.partial,
                onChanged: (val) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(val ? 'Rule Enabled' : 'Rule Disabled'),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0, // 48x48dp touch target minimum
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Configuration saved successfully.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Save Configuration'),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      },
    );
  }
}
