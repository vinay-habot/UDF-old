// GEN-03309 — Touch-first gesture controls for chart navigation.
// Implements pinch-to-zoom and pan-drag interactions with 60fps target using M3 Elevated Cards and responsive layout.

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Mock data representing chart points for demonstration purposes.
class _MockChartPoint {
  final double x;
  final double y;
  const _MockChartPoint(this.x, this.y);
}

const List<_MockChartPoint> _kMockChartData = [
  _MockChartPoint(0.0, 10.0),
  _MockChartPoint(1.0, 25.0),
  _MockChartPoint(2.0, 15.0),
  _MockChartPoint(3.0, 40.0),
  _MockChartPoint(4.0, 35.0),
  _MockChartPoint(5.0, 60.0),
  _MockChartPoint(6.0, 55.0),
  _MockChartPoint(7.0, 80.0),
  _MockChartPoint(8.0, 70.0),
  _MockChartPoint(9.0, 95.0),
  _MockChartPoint(10.0, 85.0),
];

/// A touch-first interactive chart widget supporting pinch-to-zoom and pan-drag.
/// Enforces 48x48dp minimum touch targets and Material 3 design tokens.
class ChartGestureControls extends StatefulWidget {
  const ChartGestureControls({super.key});

  @override
  State<ChartGestureControls> createState() => _ChartGestureControlsState();
}

class _ChartGestureControlsState extends State<ChartGestureControls> {
  TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (>=840dp)
        final bool isMobile = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // M3 Status Chip for health indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chart Navigation',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Chip(
                    avatar: Icon(
                      Icons.check_circle_outline,
                      size: 18.0,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    label: const Text('Pass'),
                    backgroundColor: colorScheme.secondaryContainer,
                    labelStyle: TextStyle(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // M3 Elevated Card Level 2 (3dp elevation)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 3.0,
                surfaceTintColor: colorScheme.surfaceTint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SizedBox(
                    height: isMobile ? 300.0 : 450.0,
                    width: double.infinity,
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.5,
                      maxScale: 5.0,
                      panEnabled: true,
                      scaleEnabled: true,
                      child: CustomPaint(
                        painter: _ChartPainter(
                          data: _kMockChartData,
                          lineColor: colorScheme.primary,
                          pointColor: colorScheme.secondary,
                          gridColor: colorScheme.outlineVariant,
                          backgroundColor: colorScheme.surface,
                        ),
                        size: Size(constraints.maxWidth - 32.0, isMobile ? 300.0 : 450.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (!isMobile)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildKpiCard(
                        context,
                        title: 'Smoothness',
                        value: '60 fps',
                        icon: Icons.speed,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: _buildKpiCard(
                        context,
                        title: 'Latency',
                        value: '<100ms',
                        icon: Icons.timer_outlined,
                      ),
                    ),
                  ],
                ),
              ),

            if (isMobile) ...[
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildKpiCard(
                  context,
                  title: 'Gesture Pan/Zoom Smoothness',
                  value: '60 fps (Target)',
                  icon: Icons.touch_app,
                ),
              ),
            ],

            const SizedBox(height: 24.0),

            // Reset Button with 48x48dp touch target
            Center(
              child: SizedBox(
                height: 48.0,
                width: 48.0,
                child: IconButton(
                  onPressed: () {
                    _transformationController.value = Matrix4.identity();
                  },
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset Zoom & Pan',
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceTint,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 24.0),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<_MockChartPoint> data;
  final Color lineColor;
  final Color pointColor;
  final Color gridColor;
  final Color backgroundColor;

  _ChartPainter({
    required this.data,
    required this.lineColor,
    required this.pointColor,
    required this.gridColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    for (int i = 0; i <= 5; i++) {
      double y = (size.height / 5) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (int i = 0; i <= 10; i++) {
      double x = (size.width / 10) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final double maxX = data.map((e) => e.x).reduce(math.max);
    final double maxY = data.map((e) => e.y).reduce(math.max);

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path path = Path();
    bool first = true;

    for (final point in data) {
      final double dx = (point.x / maxX) * size.width;
      final double dy = size.height - ((point.y / maxY) * size.height);
      if (first) {
        path.moveTo(dx, dy);
        first = false;
      } else {
        path.lineTo(dx, dy);
      }
    }

    canvas.drawPath(path, linePaint);

    final Paint pointPaint = Paint()
      ..color = pointColor
      ..style = PaintingStyle.fill;

    for (final point in data) {
      final double dx = (point.x / maxX) * size.width;
      final double dy = size.height - ((point.y / maxY) * size.height);
      canvas.drawCircle(Offset(dx, dy), 4.0, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.pointColor != pointColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}