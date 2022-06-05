import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cop_belgium_app/models/episodes_model.dart';
import 'package:cop_belgium_app/providers/audio_notifier.dart';
import 'package:cop_belgium_app/screens/podcast_screens/widgets/podcast_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

const double _iconSize = 32;

class PodcastPlayerScreen extends StatefulWidget {
  const PodcastPlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  late final AudioPlayerNotifier audioPlayerNotifier;
  late final EpisodeModel episodeModel;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    episodeModel = Provider.of<EpisodeModel>(context, listen: false);
    audioPlayerNotifier = Provider.of<AudioPlayerNotifier>(
      context,
      listen: false,
    );

    final mediaItem = MediaItem(
      id: episodeModel.audioURL,
      title: episodeModel.title,
      duration: episodeModel.duration,
      artUri: Uri.parse(episodeModel.imageURL),
      artist: episodeModel.author,
    );

    await audioPlayerNotifier.init(item: mediaItem);
  }

  void showEpisodeInfo() {
    showCustomBottomSheet(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            episodeModel.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: kContentSpacing4),
          Text(
            episodeModel.author,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: kContentSpacing24),
          Text(
            episodeModel.description,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        const SizedBox(height: kContentSpacing32),
        _buildImage(),
        const SizedBox(height: kContentSpacing16),
        _buildTitle(),
        _buildSlider(),
        const _PlaybackControls()
      ],
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
    return Consumer<EpisodeModel>(
      builder: (context, episodeModel, _) {
        return PodcastImage(
          imageUrl: episodeModel.imageURL,
          width: 320,
          height: 320,
        );
      },
    );
  }

  Widget _buildTitle() {
    return Consumer2<EpisodeModel, AudioPlayerNotifier>(
      builder: (context, episodeModel, audioPlayerNotifier, _) {
        return Column(
          children: [
            Text(
              episodeModel.title,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kContentSpacing4),
            Text(
              audioPlayerNotifier.playState == ProcessingState.buffering
                  ? 'Buffering...'
                  : episodeModel.author,
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
  late final AudioPlayerNotifier audioPlayerNotifier;

  bool isPlaying = false;

  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  double selectedPlaybackSpeed = 1.0;

  List<double> playBackOptions = [0.5, 1.0, 1.5, 2.0, 2.5];

  @override
  void initState() {
    audioPlayerNotifier = Provider.of<AudioPlayerNotifier>(
      context,
      listen: false,
    );
    super.initState();
  }

  Future<void> play() async {
    if (audioPlayerNotifier.isPlaying == false) {
      await audioPlayerNotifier.play();
    } else {
      await audioPlayerNotifier.pause();
    }
  }

  Future<void> fastRewind() async {
    await audioPlayerNotifier.rewind();
  }

  Future<void> fastFoward() async {
    await audioPlayerNotifier.fastForward();
  }

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
    return Flexible(
      child: CustomElevatedButton(
        padding: EdgeInsets.zero,
        child: const Icon(
          Icons.replay_30_rounded,
          size: _iconSize,
          color: kBlack,
        ),
        onPressed: fastRewind,
      ),
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
          onPressed: play,
        );
      },
    );
  }

  Widget _buildFastFowardButton() {
    return CustomElevatedButton(
      padding: EdgeInsets.zero,
      child: const Icon(
        Icons.forward_30_rounded,
        size: _iconSize,
        color: kBlack,
      ),
      onPressed: fastFoward,
    );
  }
}
