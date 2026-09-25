// GEN-02945 — Swipe-down gesture to convert full-screen podcast player into a mini-bar.
// Implements a DraggableScrollableSheet-based full-screen player that collapses
// into a persistent mini-player bar on swipe down, using M3 Elevated Cards and 48x48dp touch targets.

import 'package:flutter/material.dart';

/// Mock data representing the currently playing podcast episode.
class _MockPodcastEpisode {
  final String id;
  final String title;
  final String author;
  final String artworkUrl;
  final Duration duration;
  final Duration position;

  const _MockPodcastEpisode({
    required this.id,
    required this.title,
    required this.author,
    required this.artworkUrl,
    required this.duration,
    required this.position,
  });
}

const _MockPodcastEpisode _kMockEpisode = _MockPodcastEpisode(
  id: 'ep_mock_001',
  title: 'Architecture & Implementation Governance',
  author: 'UDF Engineering Team',
  artworkUrl: 'assets/images/podcast_cover.png',
  duration: Duration(minutes: 45, seconds: 30),
  position: Duration(minutes: 12, seconds: 15),
);

/// A widget that wraps the app content and provides a swipe-down gesture
/// to convert the full-screen podcast player into a mini-bar.
class SwipeDownMiniPlayerGen02945 extends StatefulWidget {
  final Widget child;

  const SwipeDownMiniPlayerGen02945({
    super.key,
    required this.child,
  });

  @override
  State<SwipeDownMiniPlayerGen02945> createState() =>
      _SwipeDownMiniPlayerGen02945State();
}

class _SwipeDownMiniPlayerGen02945State
    extends State<SwipeDownMiniPlayerGen02945> with TickerProviderStateMixin {
  late final DraggableScrollableController _draggableController;
  bool _isPlaying = true;

  static const double _kMiniBarFraction = 0.12;
  static const double _kFullScreenFraction = 1.0;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _expandPlayer() {
    _draggableController.animateTo(
      _kFullScreenFraction,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _collapsePlayer() {
    _draggableController.animateTo(
      _kMiniBarFraction,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        // Underlying app content
        widget.child,

        // Podcast Player Sheet
        DraggableScrollableSheet(
          controller: _draggableController,
          initialChildSize: _kMiniBarFraction,
          minChildSize: _kMiniBarFraction,
          maxChildSize: _kFullScreenFraction,
          snap: true,
          snapSizes: const [_kMiniBarFraction, _kFullScreenFraction],
          builder: (BuildContext context, ScrollController scrollController) {
            return Material(
              elevation: 3.0, // M3 Elevated Card Level 2 (3dp)
              shadowColor: colorScheme.shadow.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
              color: colorScheme.surfaceContainerHighest,
              child: AnimatedBuilder(
                animation: _draggableController,
                builder: (context, child) {
                  final double currentSize =
                      _draggableController.isAttached
                          ? _draggableController.size
                          : _kMiniBarFraction;

                  if (currentSize < 0.5) {
                    return _buildMiniBar(theme, scrollController);
                  } else {
                    return _buildFullScreenPlayer(
                        theme, scrollController, currentSize);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMiniBar(ThemeData theme, ScrollController scrollController) {
    final colorScheme = theme.colorScheme;
    final progress = _kMockEpisode.position.inMilliseconds /
        _kMockEpisode.duration.inMilliseconds;

    return GestureDetector(
      onTap: _expandPlayer,
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          _collapsePlayer();
        } else if (details.primaryVelocity != null &&
            details.primaryVelocity! < -100) {
          _expandPlayer();
        }
      },
      child: ListView(
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Progress indicator line at the top of the mini bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceVariant,
            valueColor:
                AlwaysStoppedAnimation<Color>(colorScheme.primary),
            minHeight: 2.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Artwork placeholder
                Container(
                  width: 48.0, // 48x48dp touch target / visual size
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.podcasts_rounded,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12.0),
                // Episode Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _kMockEpisode.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _kMockEpisode.author,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Play/Pause Button (48x48dp touch target)
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: IconButton(
                    onPressed: _togglePlayPause,
                    icon: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: colorScheme.primary,
                    ),
                    iconSize: 32.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenPlayer(
    ThemeData theme,
    ScrollController scrollController,
    double sheetFraction,
  ) {
    final colorScheme = theme.colorScheme;
    final progress = _kMockEpisode.position.inMilliseconds /
        _kMockEpisode.duration.inMilliseconds;

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        // Drag handle for swipe-down gesture
        GestureDetector(
          onVerticalDragUpdate: (details) {
            // The DraggableScrollableSheet handles the drag natively
          },
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12.0, bottom: 8.0),
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),

        // Swipe down instruction chip (M3 Status Chip)
        Center(
          child: Chip(
            avatar: Icon(Icons.swipe_down_alt_rounded,
                size: 18, color: colorScheme.onSecondaryContainer),
            label: Text('Swipe down to minimize',
                style: theme.textTheme.labelMedium),
            backgroundColor: colorScheme.secondaryContainer,
            labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
          ),
        ),
        const SizedBox(height: 32.0),

        // Large Artwork Placeholder
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 24.0,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(
              Icons.podcasts_rounded,
              size: 120.0,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 48.0),

        // Title & Author
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _kMockEpisode.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _kMockEpisode.author,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32.0),

        // Progress Slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 14.0),
                  activeTrackColor: colorScheme.primary,
                  inactiveTrackColor: colorScheme.surfaceVariant,
                  thumbColor: colorScheme.primary,
                ),
                child: Slider(
                  value: progress.clamp(0.0, 1.0),
                  onChanged: (_) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_kMockEpisode.position),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _formatDuration(_kMockEpisode.duration),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        // Playback Controls (48x48dp touch targets)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                  Icons.repeat_rounded, colorScheme, theme, false),
              _buildControlButton(
                  Icons.skip_previous_rounded, colorScheme, theme, true),
              // Primary Play/Pause (Larger)
              SizedBox(
                width: 72.0,
                height: 72.0,
                child: FilledButton(
                  onPressed: _togglePlayPause,
                  style: FilledButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: Icon(
                    _isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 40.0,
                  ),
                ),
              ),
              _buildControlButton(
                  Icons.skip_next_rounded, colorScheme, theme, true),
              _buildControlButton(
                  Icons.shuffle_rounded, colorScheme, theme, false),
            ],
          ),
        ),
        const SizedBox(height: 48.0),
      ],
    );
  }

  Widget _buildControlButton(
    IconData icon,
    ColorScheme colorScheme,
    ThemeData theme,
    bool isPrimaryAction,
  ) {
    return SizedBox(
      width: 48.0, // 48x48dp touch target
      height: 48.0,
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon),
        color: isPrimaryAction
            ? colorScheme.onSurface
            : colorScheme.onSurfaceVariant,
        iconSize: isPrimaryAction ? 32.0 : 24.0,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

/// Wrapper class needed because AnimatedBuilder requires a Listenable.
/// DraggableScrollableController implements Listenable in Flutter 3.x+.
class AnimatedBuilder extends StatelessWidget {
  final DraggableScrollableController animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilderInternal(
      controller: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilderInternal extends StatefulWidget {
  final DraggableScrollableController controller;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilderInternal({
    super.key,
    required this.controller,
    required this.builder,
    this.child,
  });

  @override
  State<AnimatedBuilderInternal> createState() =>
      _AnimatedBuilderInternalState();
}

class _AnimatedBuilderInternalState extends State<AnimatedBuilderInternal> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant AnimatedBuilderInternal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}