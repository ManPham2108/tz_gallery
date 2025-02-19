import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

/// A widget that provides a method of building widgets using an interpolated
/// position value for [VideoPlayerController].
class SmoothVideoProgress extends StatefulWidget {
  const SmoothVideoProgress({
    super.key,
    required this.controller,
    required this.builder,
    this.child,
  });

  /// The [VideoPlayerController] to build a progress widget for.
  final VideoPlayerController controller;

  /// The builder function.
  ///
  /// [progress] holds the interpolated current progress of the video. Use
  /// [duration] (the total duration of the video) to calculate a relative value
  /// for a slider for example for convenience.
  /// [child] holds the widget you passed into the constructor of this widget.
  /// Use that to optimize rebuilds.
  final Widget Function(BuildContext context, Duration progress,
      Duration duration, Widget? child) builder;

  /// An optional child that will be passed to the [builder] function and helps
  /// you optimize rebuilds.
  final Widget? child;

  @override
  State<SmoothVideoProgress> createState() => _SmoothVideoProgressState();
}

class _SmoothVideoProgressState extends State<SmoothVideoProgress>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late ValueListenable<VideoPlayerValue> _videoPlayerListener;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    // Create an animation controller with the duration of the video.
    _videoPlayerListener = _controller;
    _animationController = AnimationController(
      vsync: this,
      duration: _controller.value.duration,
    );

    // Listen to the video player's value changes
    _videoPlayerListener.addListener(_onPlayerValueChanged);
    _initPosition();
  }

  @override
  void dispose() {
    // Dispose the animation controller and remove the listener
    _videoPlayerListener.removeListener(_onPlayerValueChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _initPosition() {
    final value = _videoPlayerListener.value;
    if (value.isPlaying) return;
    _animationController.value =
        value.position.inMilliseconds / value.duration.inMilliseconds;
  }

  void _onPlayerValueChanged() {
    final value = _videoPlayerListener.value;
    final targetRelativePosition =
        value.position.inMilliseconds / value.duration.inMilliseconds;
    final currentPosition = Duration(
        milliseconds:
            (_animationController.value * value.duration.inMilliseconds)
                .round());
    final offset = value.position - currentPosition;

    bool canPlay = value.isPlaying;

    final correct =
        canPlay && offset.inMilliseconds > -500 && offset.inMilliseconds < -50;
    final correction = const Duration(milliseconds: 500) - offset;
    final targetPos =
        correct ? _animationController.value : targetRelativePosition;
    final duration = correct ? value.duration + correction : value.duration;

    _animationController.duration = duration;

    if (canPlay) {
      _animationController.forward(from: targetPos);
    } else {
      _animationController.value = targetRelativePosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = _videoPlayerListener.value;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final millis =
            _animationController.value * value.duration.inMilliseconds;
        return widget.builder(
          context,
          Duration(milliseconds: millis.round()),
          value.duration,
          child,
        );
      },
      child: widget.child,
    );
  }
}
