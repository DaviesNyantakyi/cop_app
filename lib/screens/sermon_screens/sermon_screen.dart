import 'package:audio_service/audio_service.dart';
import 'package:cop_belgium_app/models/podcast_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/providers/audio_notifier.dart';
import 'package:cop_belgium_app/screens/sermon_screens/sermon_detail_screen.dart';
import 'package:cop_belgium_app/screens/sermon_screens/sermon_player_screen.dart';
import 'package:cop_belgium_app/screens/sermon_screens/widgets/sermon_card.dart';
import 'package:cop_belgium_app/screens/sermon_screens/widgets/sermon_screen_skeleton.dart';
import 'package:cop_belgium_app/services/podcast_service.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/greeting.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/widgets/custom_bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';

class SermonsScreen extends StatefulWidget {
  const SermonsScreen({Key? key}) : super(key: key);

  @override
  State<SermonsScreen> createState() => _SermonsScreenState();
}

class _SermonsScreenState extends State<SermonsScreen> {
  late final userStream = CloudFire().getUserStream(
    uid: FirebaseAuth.instance.currentUser!.uid,
  );
  PodcastService podcastNotifier = PodcastService();
  late final Future<PodcastModel?> getPodcasts;

  void showPlayerScreen() {
    AudioPlayerNotifier audioPlayerNotifier = Provider.of<AudioPlayerNotifier>(
      context,
      listen: false,
    );
    showCustomBottomSheet(
      height: MediaQuery.of(context).size.height * 0.85,
      context: context,
      child: MultiProvider(
        providers: [
          Provider<MediaItem>.value(
            value: audioPlayerNotifier.currentMediaItem!,
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
  void initState() {
    getPodcasts = podcastNotifier.getPodcasts(context: context);

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
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
                children: [
                  _buildGreetingText(),
                  const SizedBox(height: kContentSpacing32),
                  _buildPodcastsGridView(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: Text(
        'Sermons',
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: [
        Consumer<AudioPlayerNotifier>(
          builder: (context, audioPlayerNotifier, _) {
            String image;
            if (audioPlayerNotifier.currentMediaItem == null) {
              return Container();
            }
            if (audioPlayerNotifier.isPlaying == false &&
                audioPlayerNotifier.currentMediaItem != null) {
              image = 'assets/images/audio_wave_static.png';
            } else {
              image = 'assets/images/audio_wave_playing.gif';
            }
            return CustomElevatedButton(
              splashColor: Colors.transparent,
              padding:
                  const EdgeInsets.symmetric(horizontal: kContentSpacing16),
              child: Image.asset(
                image,
                width: 32,
              ),
              onPressed: showPlayerScreen,
            );
          },
        )
      ],
    );
  }

  Widget _buildGreetingText() {
    final String greeting = Greeting.showGreetings();

    return StreamBuilder<UserModel?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: kBlue),
              ),
              snapshot.data?.displayName == null ||
                      snapshot.data?.displayName?.isEmpty == true
                  ? Container()
                  : Text(
                      snapshot.data?.displayName ?? '',
                      style: Theme.of(context).textTheme.headline6,
                    )
            ],
          );
        }
        return Text(
          greeting,
          style: Theme.of(context).textTheme.headline6?.copyWith(color: kBlue),
        );
      },
    );
  }

  Widget _buildPodcastsGridView() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return FutureBuilder(
          future: getPodcasts,
          builder: (context, snapshot) {
            bool isLoading = false;

            if (snapshot.connectionState == ConnectionState.waiting) {
              isLoading = true;
            } else {
              isLoading = false;
            }

            if (snapshot.hasError) {
              return CustomErrorWidget(
                onPressed: () async {
                  setState(() {});
                },
              );
            }

            return Skeleton(
              isLoading: isLoading,
              skeleton: const SermonScreenSkeleton(),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: podcastNotifier.podcasts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount(screenInfo),
                  mainAxisExtent: 250,
                  crossAxisSpacing: gradSpacing(screenInfo),
                ),
                itemBuilder: (context, index) {
                  return SermonCard(
                    title: podcastNotifier.podcasts[index].title,
                    imageUrl: podcastNotifier.podcasts[index].imageURL,
                    onPressed: () {
                      final audioPlayerNotifier =
                          Provider.of<AudioPlayerNotifier>(
                        context,
                        listen: false,
                      );
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              Provider<PodcastModel>.value(
                                value: podcastNotifier.podcasts[index],
                              ),
                              ChangeNotifierProvider<AudioPlayerNotifier>.value(
                                value: audioPlayerNotifier,
                              ),
                            ],
                            child: const SermonDetailScreen(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
