import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class AppFps extends StatefulWidget {
  const AppFps({super.key});

  @override
  _AppFpsState createState() => _AppFpsState();
}

class _AppFpsState extends State<AppFps> with TickerProviderStateMixin {
  final int maxFrameDurations = 60;
  final List<Duration> frameDurations = <Duration>[];

  Ticker? _fpsTicker;
  Duration? previousFrameDuration;

  @override
  void initState() {
    _fpsTicker = createTicker(_updateFrameDurations)..start();
    super.initState();
  }

  @override
  void dispose() {
    _fpsTicker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final num lastFps = frameDurations.isNotEmpty ? _calculateFramesPerSecond(frameDurations.last) : 0;
    return Text(
      'Last FPS: ${lastFps.toStringAsFixed(0)}',
    );
  }

  double _calculateFramesPerSecond(Duration frameDuration) {
    return 1 / (frameDuration.inMilliseconds / 1000);
  }

  void _updateFrameDurations(Duration currentFrameDuration) {
    setState(
      () {
        if (previousFrameDuration != null) {
          frameDurations.add(currentFrameDuration - previousFrameDuration!);
        }
        if (frameDurations.length > maxFrameDurations) {
          frameDurations.removeAt(0);
        }
        previousFrameDuration = currentFrameDuration;
      },
    );
  }
}
