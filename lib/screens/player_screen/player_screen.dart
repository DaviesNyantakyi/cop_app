import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/widgets/custom_marquee.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../providers/audio_provider.dart';
import '../../utilities/constant.dart';
import '../../widgets/podcast_image.dart';

class PlayerScreen extends StatefulWidget {
  final MediaItem mediaItem;
  const PlayerScreen({Key? key, required this.mediaItem}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    initAudio();
    super.initState();
  }

  Future<void> initAudio() async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    if (audioProvider.currentMediaItem?.id == widget.mediaItem.id) {
      return;
    }

    await audioProvider.initPlayer(mediaItem: widget.mediaItem);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildImageTitle(),
        const SizedBox(height: kContentSpacing8),
        _buildSlider(context),
        const SizedBox(height: kContentSpacing12),
        _buildMediaControls()
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressBar(
              buffered: audioProvider.bufferPosition,
              thumbColor: kBlue,
              progressBarColor: kBlue,
              baseBarColor: kGreyLight,
              bufferedBarColor: kBlue.withOpacity(0.2),
              timeLabelTextStyle: Theme.of(context).textTheme.bodyText2,
              progress: audioProvider.currentPostion,
              total: audioProvider.totalDuration,
              // This is called when slider value is changed.
              onSeek: (Duration value) {
                audioProvider.seek(value);
              },
            ),
            /*  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FormalDates.playerDuration(
                      duration: audioProvider.currentPostion),
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  FormalDates.playerDuration(
                    duration: audioProvider.totalDuration,
                  ),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),*/
          ],
        );
      },
    );
  }

  Widget _buildMediaControls() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Fast rewind',
              iconSize: 42,
              onPressed: () => audioProvider.rewind(),
              icon: const Icon(
                Icons.replay_30_outlined,
                color: kBlack,
              ),
            ),
            const SizedBox(width: 18),
            IconButton(
              tooltip: 'Play & Pause',
              iconSize: 68,
              onPressed: () async {
                if (audioProvider.playerState?.playing == true) {
                  await audioProvider.pause();
                } else {
                  await audioProvider.play();
                }
              },
              //
              icon: Icon(
                audioProvider.playerState?.playing == false ||
                        audioProvider.playerState?.processingState ==
                            ProcessingState.completed
                    ? BootstrapIcons.play_circle_fill
                    : BootstrapIcons.pause_circle_fill,
              ),
            ),
            const SizedBox(width: 18),
            IconButton(
              tooltip: 'Fast foward',
              iconSize: 42,
              onPressed: () => audioProvider.fastForward(),
              icon: const Icon(
                Icons.forward_30_outlined,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageTitle() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PodcastImage(
              height: 350,
              width: double.infinity,
              imageURL: widget.mediaItem.artUri.toString(),
            ),
            const SizedBox(height: kContentSpacing24),
            SizedBox(
              height: 40,
              child: CustomMarquee(
                text: widget.mediaItem.title,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            _buildAuthor(),
          ],
        );
      },
    );
  }

  Widget _buildAuthor() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        String text = widget.mediaItem.artist ?? '';

        switch (audioProvider.playerState?.processingState) {
          case ProcessingState.loading:
            text = 'Loading...';
            break;
          case ProcessingState.buffering:
            text = 'Buffering...';
            break;
          default:
        }
        return Text(
          text,
          style: Theme.of(context).textTheme.bodyText2,
          maxLines: 1,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
