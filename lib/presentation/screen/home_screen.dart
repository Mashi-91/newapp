import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/logic/videoBloc/video_bloc.dart';
import 'package:newapp/logic/videoBloc/video_state.dart';
import 'package:newapp/presentation/screen/video_player.dart';

import '../../model/video_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoLoadedState) {
            final List<VideoModel> videos = state.videos;

            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: videos.length,
              onPageChanged: (val) {
                log(val.toString());
              },
              itemBuilder: (context, i) {
                final VideoModel data = videos[i];
                log(data.videoUrls.toString());
                return CarouselSlider(
                  options: CarouselOptions(
                    initialPage: 1,
                    height: MediaQuery.of(context).size.height,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      log(index.toString());
                    },
                  ),
                  items: data.videoUrls.map((videoUrl) {
                    return VideoPlayerWidget(
                      videoUrl: videoUrl,
                      videoId: data.videoId,
                    );
                  }).toList(),
                );
              },
            );
          } else if (state is VideoErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          }

          // Handle other states or return a default widget if needed
          return const Center(child: Text('Unhandled state'));
        },
      ),
    );
  }
}

