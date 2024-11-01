import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomPlayer extends StatefulWidget {
  const CustomPlayer({
    super.key,
    required this.cid,
    required this.playlist,
    required this.thumbnail,
    required this.aspectRatio,
  });

  final String cid;
  final String playlist;
  final String thumbnail;
  final Map<String, dynamic> aspectRatio;

  @override
  State<CustomPlayer> createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> {
  late final VideoPlayerController _controller;

  bool _showControls = false;

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.playlist,
      ),
    )..initialize().then((_) {
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _showControls = true;
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _showControls = false;
            });
          });
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          if (_showControls)
            Center(
              child: CircleAvatar(
                child: IconButton(
                  onPressed: _togglePlay,
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
