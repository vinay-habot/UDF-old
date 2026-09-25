// GEN-03121 — Video Thumbnail Full-Screen Player Overlay.
// Implements tap on video thumbnail to expand into a full-screen mobile player overlay using M3 Bottom Sheet with 48x48dp touch targets and Material You dynamic color.

import 'package:flutter/material.dart';

/// Mock data for the video thumbnail requirement.
class _MockVideoData {
  static const String title = 'UDF Platform Overview';
  static const String duration = '03:42';
  static const String thumbnailUrl = 'https://picsum.photos/seed/udfvideo/800/450';
}

class VideoThumbnailPlayerGen03121 extends StatelessWidget {
  const VideoThumbnailPlayerGen03121({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Video thumbnail, tap to expand full screen player',
      button: true,
      child: InkWell(
        onTap: () => _showFullScreenPlayer(context),
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          width: double.infinity,
          height: 200.0,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Thumbnail Image (using placeholder network image)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  _MockVideoData.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.video_library_rounded,
                          size: 64.0,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Scrim overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              // Play Button (M3 48x48dp touch target)
              Center(
                child: SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: FloatingActionButton(
                    onPressed: () => _showFullScreenPlayer(context),
                    elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: const Icon(Icons.play_arrow_rounded, size: 28.0),
                  ),
                ),
              ),
              // Duration Chip
              Positioned(
                bottom: 12.0,
                right: 12.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    _MockVideoData.duration,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Title
              Positioned(
                bottom: 12.0,
                left: 12.0,
                right: 60.0,
                child: Text(
                  _MockVideoData.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenPlayer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return _FullScreenPlayerOverlay(
          title: _MockVideoData.title,
          onClose: () => Navigator.of(bottomSheetContext).pop(),
        );
      },
    );
  }
}

class _FullScreenPlayerOverlay extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _FullScreenPlayerOverlay({
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Close Button (48x48dp touch target)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: IconButton(
                      iconSize: 24.0,
                      color: Colors.white,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: onClose,
                      tooltip: 'Close player',
                    ),
                  ),
                ],
              ),
            ),
            // Video Player Area (Mock)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 96.0,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Full-Screen Mobile Player Active',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Tap controls would appear here in production.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Controls Mock
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: 0.35,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
                minHeight: 4.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}