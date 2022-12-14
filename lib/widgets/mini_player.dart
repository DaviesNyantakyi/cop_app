import 'package:audio_service/audio_service.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/widgets/custom_marquee.dart';
import 'package:cop_belgium_app/widgets/podcast_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../providers/audio_provider.dart';
import '../utilities/constant.dart';

class MiniPlayer extends StatefulWidget {
  final MediaItem mediaItem;
  const MiniPlayer({Key? key, required this.mediaItem}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPlayer(context: context, mediaItem: widget.mediaItem),
      child: Container(
        height: 68,
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kRadius),
            topRight: Radius.circular(kRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kContentSpacing8),
          child: Row(
            children: [
              _buildImageTitle(),
              _buildPlayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageTitle() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        return Expanded(
          flex: 4,
          child: Row(
            children: [
              PodcastImage(
                width: 50,
                height: 70,
                imageURL:
                    audioProvider.currentMediaItem?.artUri.toString() ?? '',
              ),
              const SizedBox(width: kContentSpacing8),
              Expanded(
                flex: 2,
                child: _buildTitle(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayButton() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        return Expanded(
          child: IconButton(
            tooltip: 'Play & Pause',
            iconSize: 32,
            onPressed: () async {
              if (audioProvider.playerState?.playing == true) {
                await audioProvider.pause();
              } else {
                await audioProvider.play();
              }
            },
            icon: Icon(
              audioProvider.playerState?.playing == false ||
                      audioProvider.playerState?.processingState ==
                          ProcessingState.completed
                  ? BootstrapIcons.play_circle_fill
                  : BootstrapIcons.pause_circle_fill,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        String title = audioProvider.currentMediaItem?.title ?? '...';

        switch (audioProvider.playerState?.processingState) {
          case ProcessingState.loading:
            title = 'Loading...';
            break;
          case ProcessingState.buffering:
            title = 'Buffering...';
            break;
          default:
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              child: CustomMarquee(
                text: title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Text(
              audioProvider.currentMediaItem?.artist ?? '',
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        );
      },
    );
  }
}
