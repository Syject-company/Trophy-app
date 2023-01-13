import 'package:flutter/material.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:video_player/video_player.dart';

class FullScreen extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreen({Key key, this.videoPlayerController}) : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              child: VideoPlayer(widget.videoPlayerController),
            ),
            Positioned(
              bottom: 20,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (widget.videoPlayerController.value.isPlaying) {
                      widget.videoPlayerController.pause();
                    } else {
                      widget.videoPlayerController.play();
                    }
                  });
                },
                color: Colors.white,
                icon: widget.videoPlayerController.value.isPlaying
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (widget.videoPlayerController.value.volume > 0.0) {
                      widget.videoPlayerController.setVolume(0.0);
                    } else {
                      widget.videoPlayerController.setVolume(100.0);
                    }
                  });
                },
                color: Colors.white,
                icon: widget.videoPlayerController.value.volume == 0.0
                    ? Icon(Icons.volume_mute)
                    : Icon(Icons.volume_up),
              ),
            ),
            Positioned(
                bottom: 20,
                right: 50,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                  icon: Icon(
                    Icons.fullscreen,
                  ),
                )),
            VideoProgressIndicator(
              widget.videoPlayerController,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: ThemeDefaults.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
