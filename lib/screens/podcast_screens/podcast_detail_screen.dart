import 'package:audio_service/audio_service.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../models/podcast_model.dart';
import '../../providers/audio_provider.dart';
import '../../utilities/constant.dart';
import '../../utilities/custom_scroll_behavior.dart';
import '../../utilities/hive_boxes.dart';
import '../../utilities/url_launcher.dart';
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
            padding: const EdgeInsets.all(kContentSpacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: kContentSpacing24),
                const Divider(),
                _buildEpisodes()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodes() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.podcast.episodes?.length ?? 0,
      separatorBuilder: (conext, index) {
        return const SizedBox(height: kContentSpacing8);
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

  dynamic _buildAppBar() {
    return AppBar(
      toolbarHeight: 74,
      leading: const CustomBackButton(),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PodcastImage(
          imageURL: widget.podcast.image ?? '',
          width: 140,
          height: 140,
        ),
        const SizedBox(width: kContentSpacing16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.podcast.episodes?.length ?? 0} Episodes',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontWeight: FontWeight.w500, color: kGrey),
              ),
              const SizedBox(height: kContentSpacing4),
              Text(
                '${widget.podcast.title}',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: kContentSpacing4),
              Text(
                '${widget.podcast.author}',
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: kContentSpacing16),
              _buildIcons(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildIcons() {
    return ValueListenableBuilder<Box<PodcastModel>>(
        valueListenable: Hive.box<PodcastModel>('subscriptions').listenable(),
        builder: (context, subBox, _) {
          bool subScribed = false;

          final x = subBox.values.cast<PodcastModel>();
          for (var podcast in x) {
            if (podcast.id == widget.podcast.id) {
              subScribed = true;
            }
          }

          return Row(
            children: [
              IconButton(
                tooltip: subScribed ? 'Subscribed' : 'Subscribe',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  subScribed
                      ? BootstrapIcons.check_circle_fill
                      : BootstrapIcons.folder_plus,
                  color: subScribed ? kBlue : kBlack,
                ),
                onPressed: () async {
                  final subBox = HiveBoxes().getSubScriptions();
                  if (subScribed) {
                    subBox.delete(widget.podcast.id);
                  } else {
                    // If you
                    PodcastModel podModel = PodcastModel(
                      id: widget.podcast.id,
                      image: widget.podcast.image,
                      title: widget.podcast.title,
                      description: widget.podcast.description,
                      author: widget.podcast.author,
                      pageLink: widget.podcast.pageLink,
                      rss: widget.podcast.rss,
                      episodes: widget.podcast.episodes,
                    );

                    await subBox.put(widget.podcast.id, podModel);
                  }
                },
              ),
              const SizedBox(width: kContentSpacing16),
              IconButton(
                tooltip: 'Website',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  BootstrapIcons.globe,
                ),
                onPressed: () async {
                  await launchLink(url: widget.podcast.pageLink ?? '');
                },
              ),
              const SizedBox(width: kContentSpacing4),
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'RSS Feed',
                icon: const Icon(
                  BootstrapIcons.rss,
                ),
                onPressed: () => launchLink(url: widget.podcast.rss ?? ''),
              ),
            ],
          );
        });
  }
}
