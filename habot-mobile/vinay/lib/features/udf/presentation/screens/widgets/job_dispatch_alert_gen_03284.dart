// GEN-03284 — Real-Time Job Alert & Acceptance Full-Screen Dialog.
// Implements a Material 3 full-screen dispatch alert with a 60s countdown timer, haptic feedback on job offer receipt, and an Accept button that disables if the job is claimed by another provider.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mock data representing a standardized job alert payload from FCM/GCP Pub/Sub.
class JobAlertPayload {
  final String jobId;
  final String parentName;
  final String serviceType;
  final String location;
  final double estimatedEarnings;

  const JobAlertPayload({
    required this.jobId,
    required this.parentName,
    required this.serviceType,
    required this.location,
    required this.estimatedEarnings,
  });

  /// Static mock for local development without backend dependency.
  static const JobAlertPayload mock = JobAlertPayload(
    jobId: 'JOB-99281-X',
    parentName: 'Sarah Jenkins',
    serviceType: 'Emergency Childcare',
    location: '123 Maple Street, Austin, TX',
    estimatedEarnings: 85.00,
  );
}

/// Enum to track the response state machine for mistake-proofing (Poka-Yoke).
enum JobDispatchState {
  pending,
  accepted,
  expired,
  claimedByOther,
}

/// Full-screen M3 Alert Dialog for high-priority job dispatches.
class JobDispatchAlertDialog extends StatefulWidget {
  final JobAlertPayload payload;
  final ValueChanged<JobDispatchState> onDismiss;

  const JobDispatchAlertDialog({
    super.key,
    required this.payload,
    required this.onDismiss,
  });

  @override
  State<JobDispatchAlertDialog> createState() => _JobDispatchAlertDialogState();
}

class _JobDispatchAlertDialogState extends State<JobDispatchAlertDialog>
    with SingleTickerProviderStateMixin {
  static const int _initialTimeSeconds = 60;
  int _remainingSeconds = _initialTimeSeconds;
  Timer? _timer;
  JobDispatchState _state = JobDispatchState.pending;

  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _triggerHapticFeedback();
    _startCountdown();
    _initRingAnimation();
    _simulateExternalClaimCheck();
  }

  void _initRingAnimation() {
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  void _triggerHapticFeedback() {
    // UX Implementation: Haptic feedback upon receiving a job offer on mobile.
    HapticFeedback.heavyImpact();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && _state == JobDispatchState.pending) {
        setState(() {
          _remainingSeconds--;
        });
      } else if (_remainingSeconds <= 0 && _state == JobDispatchState.pending) {
        _handleTimeout();
      }
    });
  }

  /// Simulates the Poka-Yoke check where another provider might accept milliseconds prior.
  void _simulateExternalClaimCheck() {
    // In production, this listens to a WebSocket or Firestore document snapshot.
    // Mock: No external claim simulated by default to allow user interaction testing.
  }

  void _handleAccept() {
    if (_state != JobDispatchState.pending) return;

    setState(() {
      _state = JobDispatchState.accepted;
    });
    HapticFeedback.lightImpact();
    _cleanupAndDismiss();
  }

  void _handlePass() {
    if (_state != JobDispatchState.pending) return;

    setState(() {
      _state = JobDispatchState.expired; // Reusing expired/pass logic
    });
    _cleanupAndDismiss();
  }

  void _handleTimeout() {
    setState(() {
      _state = JobDispatchState.expired;
    });
    _cleanupAndDismiss();
  }

  void _handleClaimedByOther() {
    setState(() {
      _state = JobDispatchState.claimedByOther;
    });
    _cleanupAndDismiss();
  }

  void _cleanupAndDismiss() {
    _timer?.cancel();
    _ringController.dispose();
    widget.onDismiss(_state);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_ringController.isAnimating) {
      _ringController.dispose();
    }
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // UI Decision: High-contrast Material 3 action buttons
    final bool isAcceptEnabled = _state == JobDispatchState.pending;

    return Scaffold(
      backgroundColor: colorScheme.surface.withOpacity(0.95),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visual Ring Animation
              AnimatedBuilder(
                animation: _ringController,
                builder: (context, child) {
                  return Container(
                    width: 120 + (_ringController.value * 20),
                    height: 120 + (_ringController.value * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(1.0 - _ringController.value),
                        width: 4.0,
                      ),
                    ),
                    child: child,
                  );
                },
                child: Icon(
                  Icons.notifications_active_rounded,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Countdown Timer
              Text(
                _formattedTime,
                style: textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _remainingSeconds <= 10 ? colorScheme.error : colorScheme.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Incoming Job Dispatch',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),

              // Brief Job Summary Card
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryRow(
                        icon: Icons.person_outline,
                        label: 'Parent',
                        value: widget.payload.parentName,
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        icon: Icons.work_outline,
                        label: 'Service',
                        value: widget.payload.serviceType,
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        value: widget.payload.location,
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        icon: Icons.attach_money,
                        label: 'Est. Earnings',
                        value: '\$${widget.payload.estimatedEarnings.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Action Buttons
              if (_state == JobDispatchState.claimedByOther) ...[
                Text(
                  'Job accepted by another provider.',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isAcceptEnabled ? _handlePass : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: colorScheme.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Pass',
                          style: textTheme.labelLarge?.copyWith(
                            color: isAcceptEnabled ? colorScheme.onSurfaceVariant : colorScheme.onSurface.withOpacity(0.38),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: isAcceptEnabled ? _handleAccept : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
                          disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Accept Job',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Helper method to trigger the full-screen dialog from anywhere in the app.
Future<void> showJobDispatchAlert({
  required BuildContext context,
  JobAlertPayload? payload,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        child: JobDispatchAlertDialog(
          payload: payload ?? JobAlertPayload.mock,
          onDismiss: (state) {
            // Log telemetry / BigQuery metric capture here
            debugPrint('[GEN-03284] Job Dispatch Dismissed with state: $state');
          },
        ),
      );
    },
  );
}