import 'dart:math';

import 'package:cop_belgium_app/models/teaching_clip_model.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';
import 'package:cop_belgium_app/widgets/social_avatar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final TeachingClipModel teachingClipModel;
  const VideoPlayerScreen({Key? key, required this.teachingClipModel})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? videoPlayerController;

  bool isPlaying = false;

  Duration? totalDuration;
  Duration? currentPostion;

  bool visableControls = true;

  bool? isBuffering;
  @override
  void initState() {
    initVideo();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    isPlaying = false;
    isBuffering = false;
    totalDuration = null;
    currentPostion = null;
    super.dispose();
  }

  Future<void> initVideo() async {
    videoPlayerController =
        VideoPlayerController.network(widget.teachingClipModel.videoURL!)
          ..initialize().then((value) async {
            await videoPlayerController?.play();
            await videoPlayerController?.setVolume(1);
            await videoPlayerController?.setLooping(true);

            totalDuration = videoPlayerController?.value.duration;
            isPlaying = true;
          });
    hideControls();
    videoPlayerController?.addListener(() {
      currentPostion = videoPlayerController?.value.position;
      setState(() {});
      isBuffering = videoPlayerController?.value.isBuffering;
    });
    totalDuration = videoPlayerController?.value.duration;

    setState(() {});
  }

  Future<void> hideControls() async {
    Future.delayed(const Duration(milliseconds: 3500), () {
      visableControls = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildVieoPlayer(),
        _buildControls(),
      ],
    );
  }

  Widget _buildVieoPlayer() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return GestureDetector(
          child: Container(
            width: screenInfo.screenSize.width,
            height: screenInfo.screenSize.height,
            decoration: const BoxDecoration(
              color: kBlack,
            ),
            child: videoPlayerController?.value.isInitialized == true
                ? Center(
                    child: AspectRatio(
                      aspectRatio:
                          videoPlayerController?.value.aspectRatio ?? 9 / 16,
                      child: VideoPlayer(
                        videoPlayerController!,
                      ),
                    ),
                  )
                : const Center(
                    child: CustomCircularProgressIndicator(),
                  ),
          ),
          onTap: () {
            if (visableControls) {
              visableControls = false;
            } else {
              visableControls = true;
            }
            setState(() {});
          },
        );
      },
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 0,
      child: Visibility(
        visible: visableControls,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(
            horizontal: kContentSpacing16,
          ).copyWith(
            top: kContentSpacing16,
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: kBlack.withOpacity(0.6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              _buildSlider(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildAvatar() {
    return Expanded(
      child: Row(
        children: [
          SocialAvatar(
            circleAvatarRadius: 24,
            headerText: Text(
              widget.teachingClipModel.speaker?['name'],
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: kWhite, fontWeight: FontWeight.normal),
            ),
            subheaderText: Text(
              widget.teachingClipModel.title!,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: kWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            imageURL: widget.teachingClipModel.speaker?['imageURL'],
          )
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              if (isPlaying) {
                await videoPlayerController?.pause();
              } else {
                await videoPlayerController?.play();
              }
              isPlaying = !isPlaying;
              setState(() {});
            },
            child: isBuffering == true
                ? const CustomCircularProgressIndicator(
                    color: kWhite,
                  )
                : Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
          const SizedBox(
            width: kContentSpacing12,
          ),
          Expanded(
            child: Listener(
              onPointerMove: (moveEvent) {},
              child: Slider(
                max: totalDuration?.inSeconds.toDouble() ?? 100,
                value: min(
                  currentPostion?.inSeconds.toDouble() ?? 0,
                  totalDuration?.inSeconds.toDouble() ?? 0,
                ),
                onChanged: (value) async {
                  await videoPlayerController?.seekTo(
                    Duration(seconds: value.toInt()),
                  );

                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            width: kContentSpacing8,
          ),
          Text(
            FormalDates.episodeDuration(
              duration: totalDuration!,
            ),
            style:
                Theme.of(context).textTheme.bodyText2?.copyWith(color: kWhite),
          )
        ],
      ),
    );
  }
}
