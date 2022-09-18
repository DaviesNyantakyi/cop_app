import 'package:audio_service/audio_service.dart';
import 'package:cop_belgium_app/utilities/hive_boxes.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../models/podcast_model.dart';
import '../../providers/audio_provider.dart';
import '../../services/podcast_service.dart';
import '../../utilities/constant.dart';
import '../../utilities/custom_scroll_behavior.dart';
import '../../widgets/episode_tile.dart';
import '../../widgets/podcast_image.dart';

class PodcastDetailScreen extends StatefulWidget {
  final PodcastModel podcast;
  const PodcastDetailScreen({
    Key? key,
    required this.podcast,
  }) : super(key: key);

  @override
  State<PodcastDetailScreen> createState() => _PodcastDetailScreenState();
}

class _PodcastDetailScreenState extends State<PodcastDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: kContentSpacing8),
                _buildDescription(),
                const SizedBox(height: kContentSpacing24),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kContentSpacing16),
                  child: Text(
                    'Episodes',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const Divider(),
                _buildEpisodes()
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      toolbarHeight: 74,
      leading: const CustomBackButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: kContentSpacing16).copyWith(
        top: kContentSpacing16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              PodcastImage(
                imageURL: widget.podcast.image ?? '',
                width: 120,
              ),
              const SizedBox(height: kContentSpacing8),
              _buildSubscribeButton(),
            ],
          ),
          const SizedBox(width: kContentSpacing8),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.podcast.episodes?.length ?? 0} Episodes',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.w500, color: kGrey),
                ),
                const SizedBox(height: kContentSpacing4),
                Text(
                  '${widget.podcast.title}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: kContentSpacing4),
                Text(
                  '${widget.podcast.author}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return ValueListenableBuilder<Box<PodcastModel>>(
      valueListenable: HiveBoxes().getSubScriptions().listenable(),
      builder: (context, subBox, _) {
        bool subScribed = false;

        final storedPodcasts = subBox.values.cast<PodcastModel>();
        for (var podcast in storedPodcasts) {
          if (podcast.id == widget.podcast.id) {
            subScribed = true;
          }
        }

        return CustomElevatedButton(
          backgroundColor: subScribed ? kBlue.withOpacity(0.9) : kWhite,
          side: BorderSide(
            color: subScribed ? Colors.transparent : kGrey,
          ),
          height: 38,
          width: 120,
          child: Text(
            subScribed ? 'Subscribed' : 'Subscribe',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: subScribed ? kWhite : kBlack,
                ),
          ),
          onPressed: () async {
            try {
              await PodcastService()
                  .savePodcast(podcast: widget.podcast, context: context);
            } on FirebaseException catch (e) {
              debugPrint(e.toString());

              showCustomSnackBar(
                  context: context,
                  type: CustomSnackBarType.error,
                  message: e.message ?? '');
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        );
      },
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16),
      child: ExpandableText(
        widget.podcast.description ?? '',
        expandText: 'show more',
        collapseText: 'show less',
        maxLines: 3,
        linkColor: kBlue,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _buildEpisodes() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.podcast.episodes?.length ?? 0,
      separatorBuilder: (conext, index) {
        return const Divider();
      },
      itemBuilder: (conext, index) {
        if (widget.podcast.episodes?[index] == null) {
          return Container();
        }
        return EpisodeTile(
          episode: widget.podcast.episodes![index],
          onPressed: () => showPlayer(
            context: conext,
            mediaItem: MediaItem(
              id: widget.podcast.episodes![index].id,
              title: widget.podcast.episodes![index].title ?? '',
              artist: widget.podcast.episodes![index].author,
              duration: Duration(
                seconds: widget.podcast.episodes![index].duration ?? 0,
              ),
              displayDescription: widget.podcast.episodes![index].description,
              artUri: widget.podcast.episodes![index].image != null
                  ? Uri.parse(widget.podcast.episodes![index].image!)
                  : null,
              extras: {
                'audio': widget.podcast.episodes![index].audio,
                'downloadPath': widget.podcast.episodes![index].downloadPath,
                'pubDate': widget.podcast.episodes![index].pubDate,
                'pageLink': widget.podcast.episodes![index].pageLink
              },
            ),
          ),
        );
      },
    );
  }
}
