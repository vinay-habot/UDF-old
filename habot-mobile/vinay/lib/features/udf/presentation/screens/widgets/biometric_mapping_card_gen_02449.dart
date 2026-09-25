// GEN-02449 — Biometric Hardware Trigger Mapping Status Card.
// M3 Elevated Card displaying biometric-to-hash mapping health, data freshness, and completion state for the engineering console.

import 'package:flutter/material.dart';

enum _MappingStatus { realTime, nearRealTime, delayed }

class _BiometricMappingMock {
  final String triggerId;
  final String userHashRef;
  final _MappingStatus status;
  final int freshnessMinutes;
  final DateTime timestamp;

  const _BiometricMappingMock({
    required this.triggerId,
    required this.userHashRef,
    required this.status,
    required this.freshnessMinutes,
    required this.timestamp,
  });
}

const List<_BiometricMappingMock> _mockMappings = [
  _BiometricMappingMock(
    triggerId: 'BIO-FP-001',
    userHashRef: 'USR_HASH_A7F3',
    status: _MappingStatus.realTime,
    freshnessMinutes: 0,
    timestamp: DateTime(2026, 9, 25, 10, 0, 0),
  ),
  _BiometricMappingMock(
    triggerId: 'BIO-FACE-002',
    userHashRef: 'USR_HASH_B2C1',
    status: _MappingStatus.nearRealTime,
    freshnessMinutes: 1,
    timestamp: DateTime(2026, 9, 25, 9, 59, 30),
  ),
  _BiometricMappingMock(
    triggerId: 'BIO-IRIS-003',
    userHashRef: 'USR_HASH_D9E4',
    status: _MappingStatus.delayed,
    freshnessMinutes: 6,
    timestamp: DateTime(2026, 9, 25, 9, 54, 0),
  ),
];

class BiometricMappingCardGen02449 extends StatefulWidget {
  const BiometricMappingCardGen02449({super.key});

  @override
  State<BiometricMappingCardGen02449> createState() => _BiometricMappingCardGen02449State();
}

class _BiometricMappingCardGen02449State extends State<BiometricMappingCardGen02449> {
  late List<_BiometricMappingMock> _mappings;
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    _mappings = List.from(_mockMappings);
    _startPolling();
  }

  void _startPolling() {
    _isPolling = true;
    Future.doWhile(() async {
      if (!_isPolling || !mounted) return false;
      await Future.delayed(const Duration(seconds: 30));
      if (mounted) {
        setState(() {
          _mappings = List.from(_mockMappings);
        });
      }
      return _isPolling && mounted;
    });
  }

  @override
  void dispose() {
    _isPolling = false;
    super.dispose();
  }

  void _onRefresh() {
    setState(() {
      _mappings = List.from(_mockMappings);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Biometric mappings synced successfully.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Color _statusColor(_MappingStatus status, ThemeData theme) {
    switch (status) {
      case _MappingStatus.realTime:
        return theme.colorScheme.primary;
      case _MappingStatus.nearRealTime:
        return theme.colorScheme.tertiary;
      case _MappingStatus.delayed:
        return theme.colorScheme.error;
    }
  }

  String _statusLabel(_MappingStatus status) {
    switch (status) {
      case _MappingStatus.realTime:
        return 'Real-time';
      case _MappingStatus.nearRealTime:
        return 'Near Real-time';
      case _MappingStatus.delayed:
        return 'Delayed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= 840;

    return RefreshIndicator(
      onRefresh: () async => _onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Biometric Hardware Triggers',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'GEN-02449 | Data Freshness Target: < 5 min',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              isDesktop
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: _mappings.length,
                      itemBuilder: (context, index) => _buildMappingCard(_mappings[index], theme),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _mappings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildMappingCard(_mappings[index], theme),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMappingCard(_BiometricMappingMock mapping, ThemeData theme) {
    final statusColor = _statusColor(mapping.status, theme);
    final statusLabel = _statusLabel(mapping.status);

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showDetailSheet(mapping, theme),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      mapping.triggerId,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    label: Text(
                      statusLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: statusColor.withOpacity(0.12),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'User Hash: ${mapping.userHashRef}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Freshness: ${mapping.freshnessMinutes} min',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailSheet(_BiometricMappingMock mapping, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mapping Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _detailRow('Trigger ID', mapping.triggerId, theme),
              _detailRow('User Hash Reference', mapping.userHashRef, theme),
              _detailRow('Status', _statusLabel(mapping.status), theme),
              _detailRow('Data Freshness', '${mapping.freshnessMinutes} minutes', theme),
              _detailRow(
                'Last Sync',
                '${mapping.timestamp.hour}:${mapping.timestamp.minute.toString().padLeft(2, '0')}',
                theme,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _onRefresh();
                  },
                  child: const Text('Force Re-sync'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
