// GEN-02956 — Responsive Horizontal 16:9 Video Stream Widget.
// Renders responsive horizontal 16:9 video streams as an alternative format using M3 Elevated Cards, status chips, and adaptive layouts (single-column mobile, multi-column desktop).

import 'package:flutter/material.dart';

enum StepHealthStatus { pass, fail }

class VideoStreamMockData {
  final String id;
  final String title;
  final String thumbnailUrl;
  final int latencyMs;
  final StepHealthStatus status;
  final DateTime timestamp;

  const VideoStreamMockData({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.latencyMs,
    required this.status,
    required this.timestamp,
  });
}

const List<VideoStreamMockData> kMockVideoStreams = [
  VideoStreamMockData(
    id: 'stream_001',
    title: 'Primary Feed - Camera A',
    thumbnailUrl: 'https://via.placeholder.com/640x360.png?text=Stream+1',
    latencyMs: 85,
    status: StepHealthStatus.pass,
    timestamp: DateTime(2026, 9, 25, 10, 0),
  ),
  VideoStreamMockData(
    id: 'stream_002',
    title: 'Secondary Feed - Camera B',
    thumbnailUrl: 'https://via.placeholder.com/640x360.png?text=Stream+2',
    latencyMs: 1250,
    status: StepHealthStatus.fail,
    timestamp: DateTime(2026, 9, 25, 10, 1),
  ),
  VideoStreamMockData(
    id: 'stream_003',
    title: 'Tertiary Feed - Camera C',
    thumbnailUrl: 'https://via.placeholder.com/640x360.png?text=Stream+3',
    latencyMs: 210,
    status: StepHealthStatus.pass,
    timestamp: DateTime(2026, 9, 25, 10, 2),
  ),
];

class ResponsiveVideoStreamWidget extends StatefulWidget {
  const ResponsiveVideoStreamWidget({super.key});

  @override
  State<ResponsiveVideoStreamWidget> createState() => _ResponsiveVideoStreamWidgetState();
}

class _ResponsiveVideoStreamWidgetState extends State<ResponsiveVideoStreamWidget> {
  late List<VideoStreamMockData> _streams;

  @override
  void initState() {
    super.initState();
    _streams = kMockVideoStreams;
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _streams = List.from(kMockVideoStreams)..shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final int crossAxisCount = isMobile ? 1 : (constraints.maxWidth >= 840 ? 3 : 2);

        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 16 / 9,
            ),
            itemCount: _streams.length,
            itemBuilder: (BuildContext context, int index) {
              final stream = _streams[index];
              return _VideoStreamCard(stream: stream);
            },
          ),
        );
      },
    );
  }
}

class _VideoStreamCard extends StatelessWidget {
  final VideoStreamMockData stream;

  const _VideoStreamCard({required this.stream});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isPass = stream.status == StepHealthStatus.pass;
    final Color statusColor = isPass ? Colors.green : Colors.red;
    final String statusLabel = isPass ? 'Pass' : 'Fail';

    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () => _showConfigBottomSheet(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Simulated Video Stream Background
            Container(
              color: colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  size: 64.0,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ),
            // Top Bar with Title and Status Chip
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        stream.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    _StatusChip(label: statusLabel, color: statusColor),
                  ],
                ),
              ),
            ),
            // Bottom Bar with Latency Metric
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.timer_outlined, size: 16.0, color: Colors.white70),
                    const SizedBox(width: 4.0),
                    Text(
                      '${stream.latencyMs} ms',
                      style: const TextStyle(color: Colors.white70, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfigBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stream Configuration', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16.0),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Stream ID'),
                subtitle: Text(stream.id),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: const Icon(Icons.speed),
                title: const Text('Latency Target'),
                subtitle: const Text('Floor: 1000ms | Optimal: 300ms | Ceiling: 2000ms'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Configuration saved successfully.'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Apply Settings'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
