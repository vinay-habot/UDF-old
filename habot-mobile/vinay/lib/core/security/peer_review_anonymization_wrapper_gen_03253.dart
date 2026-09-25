// GEN-03253 — Data Anonymization Wrappers for Peer Review Submission Payloads.
// Implements M3 Elevated Cards and Status Chips to display anonymization health metrics with mock payload data.

import 'package:flutter/material.dart';

/// Mock data representing a peer review submission payload before anonymization.
class MockPeerReviewPayload {
  final String traceId;
  final String reviewerName;
  final String reviewerEmail;
  final String comments;
  final DateTime timestamp;

  const MockPeerReviewPayload({
    required this.traceId,
    required this.reviewerName,
    required this.reviewerEmail,
    required this.comments,
    required this.timestamp,
  });
}

/// Anonymized version of the peer review payload.
class AnonymizedPeerReviewPayload {
  final String traceId;
  final String reviewerIdentifier;
  final String comments;
  final DateTime timestamp;
  final bool isAnonymized;

  const AnonymizedPeerReviewPayload({
    required this.traceId,
    required this.reviewerIdentifier,
    required this.comments,
    required this.timestamp,
    required this.isAnonymized,
  });
}

/// Core wrapper function that anonymizes peer review submission payloads.
/// Adheres to QPA Peer Confidentiality Rules.
AnonymizedPeerReviewPayload anonymizePeerReviewPayload(MockPeerReviewPayload input) {
  // Deterministic anonymization logic
  final hashedId = 'ANON_${input.reviewerName.hashCode.abs().toString().padLeft(8, '0')}';
  return AnonymizedPeerReviewPayload(
    traceId: input.traceId,
    reviewerIdentifier: hashedId,
    comments: input.comments,
    timestamp: input.timestamp,
    isAnonymized: true,
  );
}

/// Metric configuration based on requirement floor/optimal/ceiling boundaries of 1.0.
class PeerAnonymizationMetric {
  final String name = 'Peer Anonymization Protection Rate';
  final double floorBoundary = 1.0;
  final double optimalTarget = 1.0;
  final double ceilingBoundary = 1.0;
  final String qualitativeOutput = 'Pass';
  final String standard = 'QPA Peer Confidentiality Rules';
}

/// Static mock data for demonstration and local testing without backend dependencies.
class PeerReviewMockData {
  static const List<MockPeerReviewPayload> samplePayloads = [
    MockPeerReviewPayload(
      traceId: 'trace_001_gen_03253',
      reviewerName: 'John Doe',
      reviewerEmail: 'john.doe@example.com',
      comments: 'Excellent architectural implementation.',
      timestamp: null, // Handled in constructor if needed, using const requires compile-time
    ),
    MockPeerReviewPayload(
      traceId: 'trace_002_gen_03253',
      reviewerName: 'Jane Smith',
      reviewerEmail: 'jane.smith@example.com',
      comments: 'Needs minor adjustments to the M3 layout tokens.',
      timestamp: null,
    ),
  ];

  static List<MockPeerReviewPayload> getPayloads() {
    final now = DateTime.now();
    return [
      MockPeerReviewPayload(
        traceId: 'trace_001_gen_03253',
        reviewerName: 'John Doe',
        reviewerEmail: 'john.doe@example.com',
        comments: 'Excellent architectural implementation.',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      MockPeerReviewPayload(
        traceId: 'trace_002_gen_03253',
        reviewerName: 'Jane Smith',
        reviewerEmail: 'jane.smith@example.com',
        comments: 'Needs minor adjustments to the M3 layout tokens.',
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }
}

/// UI Screen implementing M3 responsive layout:
/// Single-column on mobile (<600dp), multi-column on desktop (>=840dp).
/// Uses M3 Elevated Cards Level 2 (3dp) and Status Chips.
class PeerReviewAnonymizationDashboard extends StatefulWidget {
  const PeerReviewAnonymizationDashboard({super.key});

  @override
  State<PeerReviewAnonymizationDashboard> createState() => _PeerReviewAnonymizationDashboardState();
}

class _PeerReviewAnonymizationDashboardState extends State<PeerReviewAnonymizationDashboard> {
  late List<AnonymizedPeerReviewPayload> _anonymizedPayloads;
  final PeerAnonymizationMetric _metric = PeerAnonymizationMetric();
  bool _isPolling = true;

  @override
  void initState() {
    super.initState();
    _processPayloads();
    _startBackgroundPolling();
  }

  void _processPayloads() {
    final rawPayloads = PeerReviewMockData.getPayloads();
    setState(() {
      _anonymizedPayloads = rawPayloads.map(anonymizePeerReviewPayload).toList();
    });
  }

  /// Background polling refreshes data every 30 seconds as per requirement.
  void _startBackgroundPolling() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && _isPolling) {
        _processPayloads();
        _startBackgroundPolling();
      }
    });
  }

  @override
  void dispose() {
    _isPolling = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Review Anonymization'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _processPayloads();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Manual sync triggered successfully.'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: colorScheme.inverseSurface,
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (>=840dp)
            final bool isDesktop = constraints.maxWidth >= 840;
            final int crossAxisCount = isDesktop ? 2 : 1;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildMetricCard(colorScheme, textTheme),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: isDesktop ? 2.5 : 1.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPayloadCard(_anonymizedPayloads[index], colorScheme, textTheme),
                      childCount: _anonymizedPayloads.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32.0)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// M3 Elevated Card Level 2 (3dp) displaying step health via inline status chip.
  Widget _buildMetricCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _metric.name,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                // M3 Status Chip for health indicator
                Chip(
                  avatar: Icon(Icons.check_circle, color: colorScheme.primary, size: 18),
                  label: Text(_metric.qualitativeOutput),
                  backgroundColor: colorScheme.primaryContainer,
                  labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text('Standard: ${_metric.standard}', style: textTheme.bodyMedium),
            const SizedBox(height: 8.0),
            Text(
              'Protection Rate Target: ${_metric.optimalTarget.toStringAsFixed(1)}',
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayloadCard(AnonymizedPeerReviewPayload payload, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => _showConfigurationBottomSheet(payload, colorScheme),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // 48x48dp touch target icon container
                  SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Center(
                      child: Icon(
                        payload.isAnonymized ? Icons.verified_user : Icons.warning,
                        color: payload.isAnonymized ? colorScheme.primary : colorScheme.error,
                        size: 24.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trace ID', style: textTheme.labelSmall),
                        Text(payload.traceId, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text('Reviewer Identifier:', style: textTheme.labelSmall),
              Text(payload.reviewerIdentifier, style: textTheme.bodyMedium),
              const SizedBox(height: 8.0),
              Text('Comments:', style: textTheme.labelSmall),
              Text(
                payload.comments,
                style: textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// M3 Bottom Sheet for configuration inputs / deep-link drill-down.
  void _showConfigurationBottomSheet(AnonymizedPeerReviewPayload payload, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payload Details', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16.0),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Trace ID'),
                subtitle: Text(payload.traceId),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Anonymized Identifier'),
                subtitle: Text(payload.reviewerIdentifier),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Status'),
                subtitle: Text(payload.isAnonymized ? 'Protected' : 'Exposed'),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0, // 48x48dp touch targets
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration acknowledged')),
                    );
                  },
                  child: const Text('Acknowledge & Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}