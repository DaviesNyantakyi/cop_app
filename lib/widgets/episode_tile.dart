import 'dart:math';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/widgets/download_button.dart';
import 'package:cop_belgium_app/widgets/podcast_image.dart';

import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../models/episode_model.dart';
import '../providers/audio_provider.dart';
import '../utilities/constant.dart';
import '../utilities/formal_dates.dart';

class EpisodeTile extends StatefulWidget {
  final EpisodeModel episode;
  final VoidCallback? onPressed;
  final bool? showImage;

  const EpisodeTile({
    Key? key,
    required this.episode,
    this.onPressed,
    this.showImage,
  }) : super(key: key);

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.showImage == true) {
      return _buildTileWithImageLayout();
    } else {
      return _buildTileNoImageLayout();
    }
  }

  Widget _buildTitle({int? maxLines}) {
    return Consumer<AudioProvider>(builder: (context, audioProvider, _) {
      return Text(
        widget.episode.title ?? '',
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w500,
              color: audioProvider.currentMediaItem?.id == widget.episode.id
                  ? kBlue
                  : kBlack,
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines ?? 2,
      );
    });
  }

  Widget _buildDescription({int? maxLines}) {
    return Text(
      widget.episode.description ?? '',
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: kBlack.withOpacity(0.65),
          ),
      maxLines: maxLines ?? 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildPlayPause(),
            const SizedBox(width: kContentSpacing8),
            _buildSlider(),
            const SizedBox(width: kContentSpacing8),
            _buildDuration(),
          ],
        ),
        DownloadButton(episode: widget.episode)
      ],
    );
  }

  Text _buildDuration() {
    return Text(
      FormalDates.playerDuration(
        duration: Duration(seconds: widget.episode.duration ?? 0),
      ),
      style: Theme.of(context).textTheme.bodyText2?.copyWith(
            color: kBlue,
          ),
    );
  }

  Widget _buildPlayPause() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        return GestureDetector(
          child: Icon(
            audioProvider.playerState?.playing == false ||
                    audioProvider.playerState?.processingState ==
                        ProcessingState.completed ||
                    audioProvider.currentMediaItem?.id != widget.episode.id
                ? BootstrapIcons.play_circle_fill
                : BootstrapIcons.pause_circle_fill,
            size: 24,
            color: kBlue,
          ),
          onTap: () {
            if (audioProvider.currentMediaItem == null ||
                widget.episode.id != audioProvider.currentMediaItem?.id) {
              audioProvider.initPlayer(
                mediaItem: MediaItem(
                  id: widget.episode.id,
                  title: widget.episode.title ?? '',
                  artist: widget.episode.author,
                  duration: Duration(
                    seconds: widget.episode.duration ?? 0,
                  ),
                  displayDescription: widget.episode.description,
                  artUri: widget.episode.image != null
                      ? Uri.parse(widget.episode.image!)
                      : null,
                  extras: {
                    'audio': widget.episode.audio,
                    'downloadPath': widget.episode.downloadPath,
                    'pubDate': widget.episode.pubDate,
                    'pageLink': widget.episode.pageLink
                  },
                ),
              );
            } else {
              if (audioProvider.playerState?.playing == true) {
                audioProvider.pause();
              } else {
                audioProvider.play();
              }
            }
          },
        );
      },
    );
  }

  Widget _buildSlider() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        return widget.episode.id == audioProvider.currentMediaItem?.id
            ? SizedBox(
                width: 100,
                child: SliderTheme(
                  data: Theme.of(context).sliderTheme.copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 0,
                          disabledThumbRadius: 0,
                        ),
                        trackHeight: 4,
                      ),
                  child: Slider(
                    value: min(
                      // the min returns the lesser numnber.
                      // If the currentPostion is greater then the totalDuration, the totalDuration will be returned.
                      audioProvider.currentPostion.inSeconds.toDouble(),
                      audioProvider.totalDuration.inSeconds.toDouble(),
                    ),

                    max: audioProvider.totalDuration.inSeconds.toDouble(),
                    // This is called when slider value is changed.
                    onChanged: (value) {},
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget _buildTileNoImageLayout() {
    return Consumer<AudioProvider>(builder: (context, audioProvider, _) {
      return InkWell(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: kContentSpacing4),
              _buildDescription(),
              const SizedBox(height: kContentSpacing4),
              _buildActions()
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTileWithImageLayout() {
    return Consumer<AudioProvider>(builder: (context, audioProvider, _) {
      return InkWell(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PodcastImage(
                imageURL: widget.episode.image ?? '',
                width: 100,
                height: 100,
              ),
              const SizedBox(width: kContentSpacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(maxLines: 2),
                    const SizedBox(height: kContentSpacing4),
                    _buildDescription(maxLines: 2),
                    const SizedBox(height: kContentSpacing4),
                    _buildActions()
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
