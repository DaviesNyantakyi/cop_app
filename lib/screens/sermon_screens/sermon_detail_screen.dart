import 'package:audio_service/audio_service.dart';
import 'package:cop_belgium_app/models/episodes_model.dart';
import 'package:cop_belgium_app/models/podcast_model.dart';
import 'package:cop_belgium_app/providers/audio_notifier.dart';
import 'package:cop_belgium_app/screens/sermon_screens/sermon_player_screen.dart';
import 'package:cop_belgium_app/screens/sermon_screens/widgets/episode_card.dart';
import 'package:cop_belgium_app/screens/sermon_screens/widgets/sermon_image.dart';

import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/custom_bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SermonDetailScreen extends StatefulWidget {
  const SermonDetailScreen({Key? key}) : super(key: key);

  @override
  State<SermonDetailScreen> createState() => _SermonDetailScreenState();
}

class _SermonDetailScreenState extends State<SermonDetailScreen> {
  void showPlayerScreen({required EpisodeModel episodeModel}) {
    final audioPlayerNotifier =
        Provider.of<AudioPlayerNotifier>(context, listen: false);

    final MediaItem mediaItem = MediaItem(
      id: episodeModel.id,
      title: episodeModel.title,
      duration: episodeModel.duration,
      artUri: Uri.parse(episodeModel.imageURL),
      artist: episodeModel.author,
      displayDescription: episodeModel.description,
    );

    showCustomBottomSheet(
      height: MediaQuery.of(context).size.height * 0.85,
      context: context,
      child: MultiProvider(
        providers: [
          Provider<MediaItem>.value(
            value: mediaItem,
          ),
          ChangeNotifierProvider<AudioPlayerNotifier>.value(
            value: audioPlayerNotifier,
          ),
        ],
        child: const SermonPlayerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: kContentSpacing16,
            vertical: kContentSpacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _BuildHeaderInfo(),
              const SizedBox(height: kContentSpacing24),
              _buildDescription(),
              const SizedBox(height: kContentSpacing32),
              _buildEpisodes(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
    );
  }

  Widget _buildDescription() {
    return Consumer<PodcastModel>(
      builder: (context, podcastModel, _) {
        return ExpandableText(
          podcastModel.description,
          expandText: 'show more',
          collapseText: 'show less',
          maxLines: 4,
          linkColor: kBlue,
          style: Theme.of(context).textTheme.bodyText1,
        );
      },
    );
  }

  Widget _buildEpisodes() {
    return Consumer<PodcastModel>(
      builder: (context, podcastModel, _) {
        return ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(height: kContentSpacing8);
          },
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: podcastModel.episodes!.length,
          itemBuilder: (context, index) {
            return EpisodeCard(
              episodeModel: podcastModel.episodes![index],
              onPressed: () {
                showPlayerScreen(episodeModel: podcastModel.episodes![index]);
              },
            );
          },
        );
      },
    );
  }
}

class _BuildHeaderInfo extends StatefulWidget {
  const _BuildHeaderInfo({Key? key}) : super(key: key);

  @override
  State<_BuildHeaderInfo> createState() => _BuildHeaderInfoState();
}

class _BuildHeaderInfoState extends State<_BuildHeaderInfo> {
  bool subscribed = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageAndTitle(),
            const SizedBox(height: kContentSpacing16),
            _buildSubscribeButton()
          ],
        );
      },
    );
  }

  Widget _buildImageAndTitle() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        if (screenInfo.isWatch) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(screenInfo: screenInfo),
              _buildTitleAuthor(),
              const SizedBox(width: kContentSpacing12),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImage(screenInfo: screenInfo),
            const SizedBox(width: kContentSpacing12),
            Expanded(child: _buildTitleAuthor()),
          ],
        );
      },
    );
  }

  Widget _buildImage({required SizingInformation screenInfo}) {
    double size = 170;

    if (screenInfo.isWatch) {
      size = 100;
    }
    return Consumer<PodcastModel>(
      builder: (context, podcastModel, _) {
        return SermonImage(
          imageUrl: podcastModel.imageURL,
          height: size,
          width: size,
        );
      },
    );
  }

  Widget _buildTitleAuthor() {
    return Consumer<PodcastModel>(
      builder: (context, podcastModel, _) {
        return ResponsiveBuilder(
          builder: (context, screenInfo) {
            double? titleFontSize =
                Theme.of(context).textTheme.headline5?.fontSize;

            if (screenInfo.isWatch) {
              titleFontSize = Theme.of(context).textTheme.bodyText1?.fontSize;
            }
            if (screenInfo.isWatch) {
              titleFontSize = Theme.of(context).textTheme.bodyText1?.fontSize;
            }
            return Padding(
              padding: const EdgeInsets.only(top: kContentSpacing8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // style: podcast!.title.length > 40 ? kSFBodyBold : kSFHeadLine2,
                  Text(
                    podcastModel.title,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: titleFontSize,
                        ),
                  ),
                  const SizedBox(height: kContentSpacing4),
                  // style: podcast!.title.length > 40 ? kSFBody2 : kSFBody,

                  Text(
                    podcastModel.author,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSubscribeButton() {
    return SizedBox(
      child: CustomElevatedButton(
        side: subscribed
            ? null
            : const BorderSide(width: kBoderWidth, color: kGrey),
        width: 170,
        height: 40,
        backgroundColor: subscribed ? kBlue : kWhite,
        child: Text(
          subscribed ? 'Subscribed' : 'Subscribe',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: subscribed ? kWhite : kBlack),
        ),
        onPressed: () {
          setState(() {
            subscribed = !subscribed;
          });
        },
      ),
    );
  }
}
