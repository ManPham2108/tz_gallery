import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tz_gallery/src/common/color.dart';
import 'package:tz_gallery/src/widgets/choose_button_widget.dart';
import 'package:tz_gallery/src/widgets/smooth_progress_bar.dart';
import 'package:tz_gallery/tz_gallery.dart';
import 'package:video_player/video_player.dart';

const brightness = Brightness.light;

class TZMediaDetailPage extends StatefulWidget {
  final AssetEntity entity;
  final bool isSelected;
  const TZMediaDetailPage(
      {super.key, required this.entity, required this.isSelected});

  @override
  State<TZMediaDetailPage> createState() => _TZMediaDetailPageState();
}

class _TZMediaDetailPageState extends State<TZMediaDetailPage> {
  AssetEntity get entity => widget.entity;
  bool get isSelected => widget.isSelected;
  bool get isVideo => entity.type == AssetType.video;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final ValueNotifier<bool> _isPlayingVideo = ValueNotifier(false);
  final ValueNotifier<bool> _isTurnOnVolume = ValueNotifier(false);
  final ValueNotifier<bool> _isDraggSlider = ValueNotifier(false);
  final ValueNotifier<double> _currentProgress = ValueNotifier(0.0);

  int? bufferDelay;
  int currPlayIndex = 0;

  @override
  void initState() {
    if (isVideo) {
      _initVideo();
    }
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _isPlayingVideo.dispose();
    _isTurnOnVolume.dispose();
    _isDraggSlider.dispose();
    _currentProgress.dispose();
    super.dispose();
  }

  Future<void> _initVideo() async {
    final fileVideo = await entity.fromAssetEntityToFile();
    if (fileVideo == null) return;

    _videoPlayerController = VideoPlayerController.file(fileVideo);
    await _videoPlayerController?.initialize();
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      customControls: const SizedBox(),
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 1),
    );
    _isPlayingVideo.value = true;
  }

  void _playVideo() {
    if (_isPlayingVideo.value == true) {
      _videoPlayerController?.pause();
      _isPlayingVideo.value = false;
    } else {
      _videoPlayerController?.play();
      _isPlayingVideo.value = true;
    }
  }

  void _tunrVolume() {
    if (_isTurnOnVolume.value == true) {
      _videoPlayerController?.setVolume(0.0);
      _isTurnOnVolume.value = false;
    } else {
      _videoPlayerController?.setVolume(1.0);
      _isTurnOnVolume.value = true;
    }
  }

  String _formatTime(double seconds) {
    int minutes = (seconds / 60).floor();
    int secs = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        statusBarBrightness:
            brightness == Brightness.light ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22.22, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, isSelected);
                      },
                      child: Row(
                        children: [
                          ChooseButtonWidget(
                            isSelect: isSelected,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isSelected ? "Deselect" : "Select",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: isVideo ? _buildVideoMedia() : _buildImageMedia(),
                ),
              ),
              _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? _buildCustomControlsVideo()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageMedia() {
    return AssetEntityImage(
      entity,
      fit: BoxFit.contain,
    );
  }

  Widget _buildVideoMedia() {
    return Center(
      child: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? GestureDetector(
              onTap: _playVideo,
              child: AspectRatio(
                aspectRatio:
                    _chewieController!.videoPlayerController.value.aspectRatio,
                child: Chewie(
                  controller: _chewieController!,
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }

  Widget _buildCustomControlsVideo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        spacing: 14,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _isDraggSlider,
            builder: (context, value, child) {
              if (value) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTimeLine(),
                );
              }
              return _buildControls();
            },
          ),
          _buildSlider(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _isPlayingVideo,
          builder: (BuildContext context, bool value, Widget? child) {
            return GestureDetector(
              onTap: _playVideo,
              child: Icon(
                value ? Icons.pause_sharp : Icons.play_arrow_sharp,
                color: Colors.white,
              ),
            );
          },
        ),
        ValueListenableBuilder<bool>(
            valueListenable: _isTurnOnVolume,
            builder: (BuildContext context, bool value, Widget? child) {
              return GestureDetector(
                onTap: _tunrVolume,
                child: Icon(
                  value ? Icons.volume_off_sharp : Icons.volume_up,
                  color: Colors.white,
                ),
              );
            }),
      ],
    );
  }

  Widget _buildTimeLine() {
    return ValueListenableBuilder<double>(
      valueListenable: _currentProgress,
      builder: (BuildContext context, double value, Widget? child) {
        return Text(
          "${_formatTime(value)} / ${_formatTime(entity.duration.toDouble())}",
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white),
        );
      },
    );
  }

  Widget _buildSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          thumbColor: Colors.white,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)),
      child: SmoothVideoProgress(
        controller: _videoPlayerController!,
        builder: (context, progress, duration, child) => SizedBox(
          height: 2,
          child: Slider(
            value: progress.inMilliseconds.toDouble(),
            max: duration.inMilliseconds.toDouble(),
            onChangeStart: (double value) {
              _isDraggSlider.value = true;
              _videoPlayerController?.pause();
            },
            onChangeEnd: (value) {
              _isDraggSlider.value = false;
              _videoPlayerController?.play();
            },
            onChanged: (value) {
              if (_isDraggSlider.value) {
                _currentProgress.value = value / 1000;
              }
              _videoPlayerController?.seekTo(
                Duration(
                  milliseconds: value.toInt(),
                ),
              );
            },
            min: 0,
            activeColor: ColorCommon.color_F4F5F6,
            inactiveColor: ColorCommon.color_F2F2F6.withValues(alpha: .4),
          ),
        ),
      ),
    );
  }
}
