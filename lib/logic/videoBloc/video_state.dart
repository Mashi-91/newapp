import 'package:equatable/equatable.dart';
import 'package:newapp/model/video_model.dart';

abstract class VideoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoLoadingState extends VideoState {}

class VideoLoadedState extends VideoState {
  final List<VideoModel> videos;
  final int views;

  VideoLoadedState({
    required this.videos,
    required this.views,
  });

  @override
  List<Object?> get props => [videos, views];


  VideoLoadedState copyWith({
    List<VideoModel>? videos,
    int? likes,
    int? dislikes,
    int? views,
  }) {
    return VideoLoadedState(
      videos: videos ?? this.videos,
      views: views ?? this.views,
    );
  }
}

class VideoErrorState extends VideoState {
  final String error;

  VideoErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}