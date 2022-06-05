import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoURL;
  const VideoPlayerScreen({Key? key, required this.videoURL}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((value) {
        videoPlayerController?.play();
        videoPlayerController?.setVolume(1);
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Container(
          width: screenInfo.screenSize.width,
          height: screenInfo.screenSize.height,
          decoration: const BoxDecoration(color: kGreyLight),
          child: videoPlayerController?.value.isInitialized == true
              ? VideoPlayer(videoPlayerController!)
              : const Center(
                  child: CustomCircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
