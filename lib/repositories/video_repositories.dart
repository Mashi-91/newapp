import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp/model/video_model.dart';

class VideoRepository {
  Future<List<VideoModel>> fetchVideos() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('newsvideo').get();

    return querySnapshot.docs.map((doc) => VideoModel.fromQueryDocumentSnapshot(doc)).toList();
  }
}