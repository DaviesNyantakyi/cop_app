import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../providers/audio_provider.dart';
import '../../utilities/constant.dart';
import '../../utilities/formal_dates.dart';
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
            SliderTheme(
              data: SliderTheme.of(context).copyWith(),
              child: Slider(
                value: min(
                  // the min returns the lesser numnber.
                  // If the currentPostion is greater then the totalDuration, the totalDuration will be returned.
                  audioProvider.currentPostion.inSeconds.toDouble(),
                  audioProvider.totalDuration.inSeconds.toDouble(),
                ),
                max: audioProvider.totalDuration.inSeconds.toDouble(),
                // This is called when slider value is changed.
                onChanged: (double value) {
                  audioProvider.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),
            Row(
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
            ),
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
              child: Marquee(
                text: widget.mediaItem.title,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                blankSpace: 8,
                velocity: 20,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
                pauseAfterRound: const Duration(seconds: 2),
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
