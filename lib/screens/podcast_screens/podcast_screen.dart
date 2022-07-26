import 'package:cop_belgium_app/screens/podcast_screens/podcast_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/podcast_model.dart';
import '../../providers/audio_provider.dart';
import '../../services/podcast_service.dart';
import '../../utilities/constant.dart';
import '../../utilities/custom_scroll_behavior.dart';
import '../../widgets/mini_player.dart';
import '../../widgets/podcast_card.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({Key? key}) : super(key: key);

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  PodcastService podcastService = PodcastService();
  @override
  void initState() {
    getPodcasts();
    super.initState();
  }

  Future<void> getPodcasts() async {
    try {
      await podcastService.fetchTrending(reload: false);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(builder: (context, audioProvider, _) {
      return RefreshIndicator(
        onRefresh: () async {
          await PodcastService().fetchTrending(
            reload: true,
          );
          if (mounted) {
            setState(() {});
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          body: SafeArea(
            child: _buildPodcasts(context),
          ),
          bottomNavigationBar: audioProvider.currentMediaItem != null
              ? MiniPlayer(
                  mediaItem: audioProvider.currentMediaItem!,
                )
              : null,
        ),
      );
    });
  }

  dynamic _buildAppBar() {
    return AppBar(
      title: Text(
        'Podcasts',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildPodcasts(BuildContext context) {
    return Consumer<AudioProvider>(builder: (context, audioProvider, _) {
      return ValueListenableBuilder<Box<PodcastModel>?>(
        valueListenable: Hive.box<PodcastModel>('podcasts').listenable(),
        builder: (context, podcastBox, _) {
          final podcasts = podcastBox?.values.toList() ?? [];
          if (podcasts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(kContentSpacing16),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: podcasts.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: kContentSpacing8,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (context, index) {
                  return PodcastCard(
                    width: double.infinity,
                    height: 180,
                    podcast: podcasts[index],
                    onTap: () async {
                      Navigator.push(context, CupertinoPageRoute(
                        builder: (context) {
                          return MultiProvider(
                            providers: [
                              ChangeNotifierProvider<AudioProvider>.value(
                                value: audioProvider,
                              ),
                            ],
                            child: PodcastDetailScreen(
                              podcast: podcasts[index],
                            ),
                          );
                        },
                      ));
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    });
  }
}
