import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cop_belgium_app/providers/audio_notifier.dart';
import 'package:cop_belgium_app/screens/sermon_screens/widgets/sermon_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/widgets/custom_bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

const double _iconSize = 32;

class SermonPlayerScreen extends StatefulWidget {
  const SermonPlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SermonPlayerScreen> createState() => _SermonPlayerScreenState();
}

class _SermonPlayerScreenState extends State<SermonPlayerScreen> {
  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  late final AudioPlayerNotifier audioPlayerNotifier;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    MediaItem chosenMediaItem = Provider.of<MediaItem>(context, listen: false);
    audioPlayerNotifier = Provider.of<AudioPlayerNotifier>(
      context,
      listen: false,
    );

    if (audioPlayerNotifier.currentMediaItem?.id != chosenMediaItem.id) {
      await audioPlayerNotifier.init(item: chosenMediaItem);
    }
  }

  void showEpisodeInfo() {
    showCustomBottomSheet(
      height: MediaQuery.of(context).size.height * 0.85,
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            audioPlayerNotifier.currentMediaItem?.title ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: kContentSpacing4),
          Text(
            audioPlayerNotifier.currentMediaItem?.artist ?? '',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: kContentSpacing20),
          Text(
            audioPlayerNotifier.currentMediaItem?.displayDescription ?? '',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: kContentSpacing32),
          _buildImage(),
          const SizedBox(height: kContentSpacing16),
          _buildTitle(),
          _buildSlider(),
          const _PlaybackControls()
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomElevatedButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.expand_more_rounded,
            size: _iconSize,
            color: kBlack,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CustomElevatedButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.info_outline_rounded,
            size: 28,
            color: kBlack,
          ),
          onPressed: showEpisodeInfo,
        )
      ],
    );
  }

  Widget _buildImage() {
    return Consumer<MediaItem>(
      builder: (context, mediaItem, _) {
        return SermonImage(
          imageUrl: mediaItem.artUri.toString(),
          width: 320,
          height: 320,
        );
      },
    );
  }

  Widget _buildTitle() {
    return Consumer2<MediaItem, AudioPlayerNotifier>(
      builder: (context, mediaItem, audioPlayerNotifier, _) {
        String author = mediaItem.artist ?? '';
        if (audioPlayerNotifier.playState == ProcessingState.buffering) {
          author = 'Buffering...';
        }
        if (audioPlayerNotifier.playState == ProcessingState.loading) {
          author = 'Loading...';
        }
        return Column(
          children: [
            Text(
              mediaItem.title,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kContentSpacing8),
            Text(
              author,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlider() {
    return Consumer<AudioPlayerNotifier>(
      builder: (context, audioPlayerNotifier, _) {
        return Column(
          children: [
            Slider(
              value: min(
                // the min returns the lesser numnber.
                // If the currentPostion is greater then the totalDuration, the totalDuration will be returned.
                audioPlayerNotifier.currentPosition.inSeconds.toDouble(),
                audioPlayerNotifier.totalDuration.inSeconds.toDouble(),
              ),
              max: audioPlayerNotifier.totalDuration.inSeconds.toDouble(),
              // This is called when slider value is changed.
              onChanged: (double value) {
                audioPlayerNotifier.seek(Duration(seconds: value.toInt()));
              },
            ),
            const SizedBox(height: kContentSpacing4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FormalDates.episodeDuration(
                    duration: audioPlayerNotifier.currentPosition,
                  ),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  FormalDates.episodeDuration(
                    duration: audioPlayerNotifier.totalDuration,
                  ),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class _PlaybackControls extends StatefulWidget {
  const _PlaybackControls({Key? key}) : super(key: key);

  @override
  State<_PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<_PlaybackControls> {
  // final double _iconSize = 32;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRewindButton(),
            _buildPlayButton(),
            _buildFastFowardButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildRewindButton() {
    return Consumer<AudioPlayerNotifier>(
      builder: (context, audioPlayerNotifier, _) {
        return Flexible(
          child: CustomElevatedButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              Icons.replay_30_rounded,
              size: _iconSize,
              color: kBlack,
            ),
            onPressed: () async {
              await audioPlayerNotifier.rewind();
            },
          ),
        );
      },
    );
  }

  Widget _buildPlayButton() {
    return Consumer<AudioPlayerNotifier>(
      builder: (context, audioPlayerNotifier, _) {
        return CustomElevatedButton(
          child: SizedBox(
            width: 70,
            child: Icon(
              audioPlayerNotifier.isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              size: 70,
              color: kBlue,
            ),
          ),
          onPressed: () async {
            if (audioPlayerNotifier.isPlaying == false) {
              await audioPlayerNotifier.play();
            } else {
              await audioPlayerNotifier.pause();
            }
          },
        );
      },
    );
  }

  Widget _buildFastFowardButton() {
    return Consumer<AudioPlayerNotifier>(
      builder: (context, audioPlayerNotifier, _) {
        return CustomElevatedButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.forward_30_rounded,
            size: _iconSize,
            color: kBlack,
          ),
          onPressed: () async {
            await audioPlayerNotifier.fastForward();
          },
        );
      },
    );
  }
}
