import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String videoId;
  final List<String> videoUrls;
  final int view;

  VideoModel({
    required this.videoId,
    required this.videoUrls,
    required this.view,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    List<String> videos = [];
    if (json['videos'] != null && json['videos'] is List) {
      json['videos'].forEach((video) {
        if (video is String) {
          videos.add(video);
        }
      });
    }

    return VideoModel(
      videoId: json['videoId'] ?? '',
      videoUrls: videos,
      view: json['view'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    List<String> videoList = videoUrls.isNotEmpty ? videoUrls : [""];

    return {
      'videoId': videoId,
      'videos': videoList,
      'view': view,
    };
  }

  factory VideoModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<String> videos = List<String>.from(snapshot.data()?['videos'] ?? []);

    return VideoModel(
      videoUrls: videos,
      view: snapshot.data()?['view'] ?? 0,
      videoId: snapshot.data()?['videoid'] ?? '',
    );
  }

  factory VideoModel.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<String> videos = List<String>.from(snapshot.data()['videos'] ?? []);

    return VideoModel(
      videoUrls: videos,
      view: snapshot.data()['view'] ?? 0,
      videoId: snapshot.data()['videoid'] ?? '',
    );
  }

  Map<String, dynamic> toSnapshot() {
    List<String> videoList = videoUrls.isNotEmpty ? videoUrls : [''];

    return {
      'videos': videoList,
      'view': view,
      'videoid': videoId,
    };
  }
}
