import 'package:bloc/bloc.dart';
import 'package:newapp/model/video_model.dart';
import 'video_event.dart';
import 'video_state.dart';
import 'package:newapp/repositories/video_repositories.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository videoRepository;
  int views = 0;

  VideoBloc({required this.videoRepository}) : super(VideoLoadingState()) {
    on<FetchVideosEvent>(_mapFetchVideosToState);
    on<ViewVideoEvent>(_mapViewVideoToState);
  }

  void _mapFetchVideosToState(FetchVideosEvent event, Emitter<VideoState> emit) async {
    emit(VideoLoadingState());
    try {
      final List<VideoModel> fetchedVideos = await videoRepository.fetchVideos();
      emit(VideoLoadedState(
        videos: fetchedVideos,
        views: views,
      ));
    } catch (e) {
      emit(VideoErrorState(error: 'Failed to fetch videos: $e'));
    }
  }

  void _mapViewVideoToState(ViewVideoEvent event, Emitter<VideoState> emit) {
    views++;
    final currentState = state;
    if (currentState is VideoLoadedState) {
      emit(currentState.copyWith(views: views));
    }
  }
}
