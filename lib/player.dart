import 'package:flutter/material.dart';
import 'package:flutter_video_player/player_controller.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'model.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends GetWidget<PlayerController> {
  const VideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Obx(
          () => Visibility(
            visible: controller.reelsList.isNotEmpty,
            child: PreloadPageView.builder(
                preloadPagesCount: 3,
                scrollDirection: Axis.vertical,
                itemCount: controller.reelsList.length,
                onPageChanged: (v) {},
                itemBuilder: (c, i) {
                  return Container(
                    color: Colors.black,
                    height: Get.height,
                    width: Get.width,
                    child: VideoPlayerWidget(
                      reels: controller.reelsList[i],
                      index: i,
                    ),
                  );
                }),
          ),
        ));
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {super.key, required this.reels, required this.index});
  final Result reels;
  final int index;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? betterController;
  @override
  void initState() {
    initVideo();
    super.initState();
  }

  initVideo() {
    betterController =
        VideoPlayerController.networkUrl(Uri.parse(widget.reels.video))
          ..initialize()
          ..setLooping(true);
  }

  @override
  void dispose() {
    betterController!.pause();
    betterController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(widget.reels.id.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction < 0.6) {
            betterController!.pause();
          } else if (info.visibleFraction >= 0.6) {
            betterController!.play();
          }
        },
        child: Center(
            child: AspectRatio(
                aspectRatio: widget.reels.aspect,
                child: VideoPlayer(betterController!))));
  }
}
