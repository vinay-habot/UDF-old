// GEN-03287 — Secure Token Storage Service integrating OS Keychain/Keystore for auth challenge tokens.
// Provides hardware-backed secure storage with M3 engineering console UI components and telemetry streaming.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Hardware-backed secure storage interface for auth challenge tokens.
/// Integrates iOS Keychain / Android Keystore via platform channels.
abstract class SecureTokenStorage {
  Future<bool> storeToken(String key, String token);
  Future<String?> getToken(String key);
  Future<bool> deleteToken(String key);
  Future<bool> isHardwareBacked();
}

/// Mock implementation of [SecureTokenStorage] for local development and testing.
/// Simulates 100% hardware-backed storage compliance.
class MockSecureTokenStorage implements SecureTokenStorage {
  final Map<String, String> _mockVault = {};

  @override
  Future<bool> storeToken(String key, String token) async {
    await Future.delayed(const Duration(milliseconds: 45));
    _mockVault[key] = token;
    TelemetryService.logEvent(
      eventType: 'TOKEN_STORED',
      traceId: 'trace_${DateTime.now().millisecondsSinceEpoch}',
      status: 'Pass',
    );
    return true;
  }

  @override
  Future<String?> getToken(String key) async {
    await Future.delayed(const Duration(milliseconds: 30));
    return _mockVault[key];
  }

  @override
  Future<bool> deleteToken(String key) async {
    await Future.delayed(const Duration(milliseconds: 20));
    _mockVault.remove(key);
    return true;
  }

  @override
  Future<bool> isHardwareBacked() async => true;
}

/// Platform channel implementation for real device Keychain/Keystore integration.
class PlatformSecureTokenStorage implements SecureTokenStorage {
  static const MethodChannel _channel = MethodChannel('com.habot.udf/secure_storage');

  @override
  Future<bool> storeToken(String key, String token) async {
    try {
      final bool result = await _channel.invokeMethod('storeToken', {'key': key, 'token': token});
      TelemetryService.logEvent(eventType: 'TOKEN_STORED', traceId: 'trace_$key', status: 'Pass');
      return result;
    } on PlatformException catch (e) {
      TelemetryService.logEvent(eventType: 'TOKEN_STORE_FAILED', traceId: 'trace_$key', status: 'Fail', metadata: e.message);
      return false;
    }
  }

  @override
  Future<String?> getToken(String key) async {
    try {
      return await _channel.invokeMethod<String>('getToken', {'key': key});
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<bool> deleteToken(String key) async {
    try {
      return await _channel.invokeMethod('deleteToken', {'key': key});
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> isHardwareBacked() async {
    try {
      return await _channel.invokeMethod<bool>('isHardwareBacked') ?? false;
    } on PlatformException {
      return false;
    }
  }
}

/// Telemetry service simulating BigQuery event streaming partitioned by event_date, clustered by trace_id.
class TelemetryService {
  static void logEvent({
    required String eventType,
    required String traceId,
    required String status,
    String? metadata,
  }) {
    final payload = {
      'event_type': eventType,
      'trace_id': traceId,
      'event_date': DateTime.now().toIso8601String(),
      'status': status,
      'metric_name': 'Token Storage Security',
      'floor_boundary': '100% Hardware-backed',
      'optimal_target': '100% Hardware-backed',
      'ceiling_boundary': 'Hardware Storage',
      'qualitative_output': status,
      'metadata': metadata,
    };
    // In production, stream to GCP BigQuery via backend API.
    debugPrint('[Telemetry -> BQ Stream]: ${jsonEncode(payload)}');
  }
}

/// Liveness Handshake monitor running every 30 seconds.
class LivenessHandshakeMonitor {
  Timer? _timer;
  final SecureTokenStorage _storage;
  final VoidCallback? onRollbackTriggered;

  LivenessHandshakeMonitor(this._storage, {this.onRollbackTriggered});

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final isSecure = await _storage.isHardwareBacked();
      if (!isSecure) {
        TelemetryService.logEvent(
          eventType: 'LIVENESS_FAILURE',
          traceId: 'liveness_monitor',
          status: 'Fail',
          metadata: 'Hardware backing lost. Triggering rollback.',
        );
        onRollbackTriggered?.call();
      } else {
        TelemetryService.logEvent(
          eventType: 'LIVENESS_CHECK',
          traceId: 'liveness_monitor',
          status: 'Pass',
        );
      }
    });
  }

  void stop() => _timer?.cancel();
}

/// Engineering Console Screen displaying step health via M3 Elevated Card with inline status chip.
/// Single-column mobile layout (<600dp), multi-column on desktop (>=840dp).
class EngineeringConsoleScreen extends StatefulWidget {
  final SecureTokenStorage storage;

  const EngineeringConsoleScreen({super.key, required this.storage});

  @override
  State<EngineeringConsoleScreen> createState() => _EngineeringConsoleScreenState();
}

class _EngineeringConsoleScreenState extends State<EngineeringConsoleScreen> {
  late final LivenessHandshakeMonitor _monitor;
  bool _isHardwareBacked = false;
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _monitor = LivenessHandshakeMonitor(widget.storage, onRollbackTriggered: () {
      if (mounted) setState(() => _isHardwareBacked = false);
    });
    _monitor.start();
    _checkStatus();
    // Background polling refreshes data every 30 seconds.
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _checkStatus());
  }

  Future<void> _checkStatus() async {
    final backed = await widget.storage.isHardwareBacked();
    if (mounted) {
      setState(() {
        _isHardwareBacked = backed;
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await _checkStatus();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Manual sync completed'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _monitor.stop();
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console - GEN-03287'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isDesktop = constraints.maxWidth >= 840;

            final cards = [
              _buildStatusCard(theme, colorScheme),
              _buildMetricCard(theme, colorScheme),
              _buildActionCard(theme, colorScheme),
            ];

            if (isMobile) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) => cards[index],
              );
            }

            return GridView.count(
              crossAxisCount: isDesktop ? 3 : 2,
              padding: const EdgeInsets.all(24),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: cards,
            );
          },
        ),
      ),
    );
  }

  /// M3 Elevated Cards Level 2 (3dp) with M3 Status Chips for health indicators.
  Widget _buildStatusCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 3,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Step Health: GEN-03287', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Keychain/Keystore Integration', style: theme.textTheme.bodyLarge),
                Chip(
                  avatar: Icon(
                    _isLoading ? Icons.sync : (_isHardwareBacked ? Icons.check_circle : Icons.error),
                    size: 18,
                    color: _isHardwareBacked ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                  ),
                  label: Text(_isLoading ? 'Checking...' : (_isHardwareBacked ? 'Pass' : 'Fail')),
                  backgroundColor: _isHardwareBacked ? colorScheme.primaryContainer : colorScheme.errorContainer,
                  labelStyle: TextStyle(
                    color: _isHardwareBacked ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 3,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Metric Configuration', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            _buildMetricRow(theme, 'Metric Name', 'Token Storage Security'),
            const SizedBox(height: 8),
            _buildMetricRow(theme, 'Floor Boundary', '100% Hardware-backed'),
            const SizedBox(height: 8),
            _buildMetricRow(theme, 'Optimal Target', '100% Hardware-backed'),
            const SizedBox(height: 8),
            _buildMetricRow(theme, 'Ceiling Boundary', 'Hardware Storage'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildActionCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 3,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Actions & Drill-down', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Read-only M3 KPI cards with deep-link drill-down.', style: theme.textTheme.bodyMedium),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48, // 48x48dp touch targets
              child: FilledButton.tonalIcon(
                onPressed: () => _showConfigBottomSheet(context),
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Configure Storage'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// M3 Bottom Sheet for configuration inputs.
  void _showConfigBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
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
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Storage Configuration', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Auth Challenge Token Key',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Configuration saved successfully.'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  },
                  child: const Text('Apply Configuration'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}