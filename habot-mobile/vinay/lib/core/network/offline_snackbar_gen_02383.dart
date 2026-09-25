// GEN-02383 — Offline Mode Snackbar Service.
// Implements gentle Material 3 snackbars to indicate when the app enters or exits offline mode using connectivity monitoring.

import 'dart:async';
import 'package:flutter/material.dart';

/// Service responsible for monitoring network connectivity state
/// and displaying gentle M3 snackbars when the app enters or exits offline mode.
class OfflineSnackbarServiceGen02383 {
  OfflineSnackbarServiceGen02383._();
  static final OfflineSnackbarServiceGen02383 instance = OfflineSnackbarServiceGen02383._();

  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  bool _isOffline = false;
  Timer? _pollingTimer;

  /// Exposes the current connectivity state as a stream.
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;

  /// Initializes the service and starts background polling every 30 seconds.
  void initialize() {
    _startPolling();
  }

  /// Disposes resources and stops polling.
  void dispose() {
    _pollingTimer?.cancel();
    _connectivityController.close();
  }

  void _startPolling() {
    // Background polling refreshes data every 30 seconds per requirement specs.
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkConnectivity();
    });
    _checkConnectivity();
  }

  /// Simulates a connectivity check. In production, replace with actual
  /// connectivity plugin logic (e.g., connectivity_plus).
  void _checkConnectivity() {
    // Mock data: randomly determine connectivity for demonstration purposes.
    // Replace this block with real connectivity checks in production.
    final bool currentlyOffline = _mockConnectivityCheck();
    if (currentlyOffline != _isOffline) {
      _isOffline = currentlyOffline;
      _connectivityController.add(_isOffline);
    }
  }

  bool _mockConnectivityCheck() {
    // Deterministic mock: always returns true (offline) for testing snackbar behavior.
    // Change to `false` to test online recovery snackbar.
    return true;
  }

  /// Forces a manual sync check, triggered by pull-to-refresh actions.
  void triggerManualSync() {
    _checkConnectivity();
  }

  /// Displays a gentle M3 snackbar based on the current offline status.
  void showOfflineStatusSnackbar(BuildContext context, bool isOffline) {
    if (!context.mounted) return;

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final String message = isOffline
        ? 'You are currently offline. Some features may be unavailable.'
        : 'You are back online.';

    final Color backgroundColor = isOffline
        ? colorScheme.errorContainer
        : colorScheme.primaryContainer;

    final Color foregroundColor = isOffline
        ? colorScheme.onErrorContainer
        : colorScheme.onPrimaryContainer;

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isOffline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
              color: foregroundColor,
              size: 24.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foregroundColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.all(16.0),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: foregroundColor,
          onPressed: () {
            messenger.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

/// A widget that listens to connectivity changes and automatically
/// displays the appropriate M3 snackbar.
class OfflineSnackbarListenerGen02383 extends StatefulWidget {
  final Widget child;

  const OfflineSnackbarListenerGen02383({
    super.key,
    required this.child,
  });

  @override
  State<OfflineSnackbarListenerGen02383> createState() => _OfflineSnackbarListenerGen02383State();
}

class _OfflineSnackbarListenerGen02383State extends State<OfflineSnackbarListenerGen02383> {
  late final StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    OfflineSnackbarServiceGen02383.instance.initialize();
    _subscription = OfflineSnackbarServiceGen02383.instance.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
  }

  void _handleConnectivityChange(bool isOffline) {
    if (mounted) {
      OfflineSnackbarServiceGen02383.instance.showOfflineStatusSnackbar(context, isOffline);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}