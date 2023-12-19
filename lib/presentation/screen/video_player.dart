import 'package:cached_video_player_fork/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp/logic/videoBloc/video_bloc.dart';
import 'package:newapp/logic/videoBloc/video_event.dart';
import 'package:newapp/repositories/video_repositories.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String videoId;

  const VideoPlayerWidget({required this.videoUrl, required this.videoId});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerController _controller;
  late VideoBloc videoBloc;
  bool isPlaying = false;
  int views = 0;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.addListener(_onVideoStateChanged);
      });
    videoBloc = VideoBloc(videoRepository: VideoRepository());
    _fetchVideoDataFromFirebase();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    videoBloc.close();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      isPlaying = _controller.value.isPlaying;
      if (isPlaying) {
        views++; // Increment views when video starts playing
        _updateViewsInFirebase(); // Update views count in Firebase
      }
    });
  }

  void _onVideoStateChanged() {
    if (!_controller.value.isPlaying &&
        _controller.value.position == Duration.zero &&
        isPlaying) {
      // Reset video to start when tapped again after pause
      _controller.seekTo(Duration.zero);
    }
  }

  Future<void> _updateViewsInFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('newsvideo')
          .doc(widget.videoId)
          .update({'views': views});
      print('Views updated successfully for video ID: ${widget.videoId}');
    } catch (e) {
      print('Error updating Views: $e');
    }
  }

  Future<void> _fetchVideoDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('newsvideo')
          .doc(widget.videoId)
          .get();

      if (snapshot.exists) {
        setState(() {
          views = snapshot['views'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching video data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CachedVideoPlayer(_controller),
                      if (!isPlaying)
                        const Icon(
                          Icons.play_arrow,
                          size: 50.0,
                          color: Colors.white,
                        ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.remove_red_eye, color: Colors.white),
                  Text(' View $views',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
