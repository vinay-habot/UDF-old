// GEN-02802 — Biometric Authentication End-to-End Test Screen.
// Validates scoped IAM token issuance upon successful biometric login with M3 status cards and KPI metrics.

import 'package:flutter/material.dart';

enum _AuthTestStatus { idle, authenticating, success, failure }

class _MockIamToken {
  final String accessToken;
  final String scope;
  final DateTime issuedAt;
  final DateTime expiresAt;

  const _MockIamToken({
    required this.accessToken,
    required this.scope,
    required this.issuedAt,
    required this.expiresAt,
  });
}

class _MockBiometricRepository {
  Future<bool> authenticate() async {
    await Future.delayed(const Duration(milliseconds: 85));
    return true;
  }

  _MockIamToken issueScopedToken() {
    final now = DateTime.now();
    return _MockIamToken(
      accessToken: 'mock_iam_token_${now.millisecondsSinceEpoch}',
      scope: 'udf:read udf:write profile:read',
      issuedAt: now,
      expiresAt: now.add(const Duration(hours: 1)),
    );
  }
}

class BiometricAuthTestScreenGen02802 extends StatefulWidget {
  const BiometricAuthTestScreenGen02802({super.key});

  @override
  State<BiometricAuthTestScreenGen02802> createState() => _BiometricAuthTestScreenStateGen02802();
}

class _BiometricAuthTestScreenStateGen02802 extends State<BiometricAuthTestScreenGen02802> {
  final _repo = _MockBiometricRepository();
  _AuthTestStatus _status = _AuthTestStatus.idle;
  _MockIamToken? _token;
  int _successCount = 0;
  int _totalCount = 0;

  double get _successRate => _totalCount == 0 ? 100.0 : (_successCount / _totalCount) * 100.0;
  bool get _isPassing => _successRate >= 90.0;

  Future<void> _runTest() async {
    setState(() {
      _status = _AuthTestStatus.authenticating;
      _token = null;
    });

    try {
      final authenticated = await _repo.authenticate();
      if (authenticated) {
        final token = _repo.issueScopedToken();
        setState(() {
          _status = _AuthTestStatus.success;
          _token = token;
          _successCount++;
          _totalCount++;
        });
      } else {
        setState(() {
          _status = _AuthTestStatus.failure;
          _totalCount++;
        });
      }
    } catch (_) {
      setState(() {
        _status = _AuthTestStatus.failure;
        _totalCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GEN-02802 Auth Test'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _runTest,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: isMobile
                  ? _buildSingleColumnLayout(theme, colorScheme)
                  : _buildMultiColumnLayout(theme, colorScheme),
            );
          },
        ),
      ),
      bottomSheet: _status == _AuthTestStatus.idle || _status == _AuthTestStatus.failure
          ? _buildBottomSheetAction(colorScheme)
          : null,
    );
  }

  Widget _buildSingleColumnLayout(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildKpiCard(theme, colorScheme),
        const SizedBox(height: 16),
        _buildStatusCard(theme, colorScheme),
        const SizedBox(height: 16),
        _buildTokenCard(theme, colorScheme),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildMultiColumnLayout(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildKpiCard(theme, colorScheme)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              _buildStatusCard(theme, colorScheme),
              const SizedBox(height: 16),
              _buildTokenCard(theme, colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Biometric Success Rate (%)', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_successRate.toStringAsFixed(1)}%',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: _isPassing ? colorScheme.primary : colorScheme.error,
                  ),
                ),
                Chip(
                  label: Text(_isPassing ? 'PASS' : 'FAIL'),
                  backgroundColor: _isPassing ? colorScheme.primaryContainer : colorScheme.errorContainer,
                  labelStyle: TextStyle(
                    color: _isPassing ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Floor: 90.0% | Target: 98.0% | Ceiling: 100.0%',
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme, ColorScheme colorScheme) {
    String statusText;
    Color statusColor;

    switch (_status) {
      case _AuthTestStatus.idle:
        statusText = 'Awaiting Execution';
        statusColor = colorScheme.outline;
        break;
      case _AuthTestStatus.authenticating:
        statusText = 'Authenticating...';
        statusColor = colorScheme.secondary;
        break;
      case _AuthTestStatus.success:
        statusText = 'IAM Token Issued Successfully';
        statusColor = colorScheme.primary;
        break;
      case _AuthTestStatus.failure:
        statusText = 'Authentication Failed';
        statusColor = colorScheme.error;
        break;
    }

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step Completion State', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_status == _AuthTestStatus.authenticating)
              const LinearProgressIndicator()
            else
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _status == _AuthTestStatus.success
                      ? Icons.check_circle
                      : _status == _AuthTestStatus.failure
                          ? Icons.error
                          : Icons.info_outline,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Text(statusText, style: theme.textTheme.bodyLarge?.copyWith(color: statusColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenCard(ThemeData theme, ColorScheme colorScheme) {
    if (_token == null) return const SizedBox.shrink();

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scoped IAM Token Details', style: theme.textTheme.titleMedium),
            const Divider(),
            _buildDetailRow('Token:', _token!.accessToken, theme),
            _buildDetailRow('Scope:', _token!.scope, theme),
            _buildDetailRow('Issued At:', _token!.issuedAt.toIso8601String(), theme),
            _buildDetailRow('Expires At:', _token!.expiresAt.toIso8601String(), theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetAction(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _status == _AuthTestStatus.authenticating ? null : _runTest,
            icon: const Icon(Icons.fingerprint, size: 24),
            label: const Text('Run Biometric Auth Test'),
          ),
        ),
      ),
    );
  }
}