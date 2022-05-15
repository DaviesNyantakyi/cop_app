import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_detail_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_player_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/widgets/podcast_card.dart';
import 'package:cop_belgium_app/screens/podcast_screens/widgets/podcast_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/greeting.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

const unsplash =
    'https://images.unsplash.com/photo-1652439578449-ea69ceb8e89d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=363&q=80';

const unsplashPhotoUrl =
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({Key? key}) : super(key: key);

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  void showPlayerScreen() {
    showCustomBottomSheet(
      initialSnap: 1,
      snappings: [1],
      context: context,
      child: const PodcastPlayerScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding(screenInfo),
                vertical: kContentSpacing24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreetingText(),
                  const SizedBox(height: kContentSpacing32),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount(screenInfo),
                      mainAxisExtent: 280,
                      crossAxisSpacing: gradSpacing(screenInfo),
                    ),
                    itemBuilder: (context, index) {
                      return PodcastCard(
                        title: 'Deep thruths',
                        imageUrl: unsplash,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const PodcastDetailScreen(),
                            ),
                          );
                        },
                      );
                    },
                  )
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
      title: const Text(
        'Podcasts',
        style: kFontH6,
      ),
      actions: [
        CustomElevatedButton(
          padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16),
          child: Image.asset(
            'assets/images/playing_wave.gif',
            width: 42,
          ),
          onPressed: showPlayerScreen,
        ),
      ],
    );
  }

  Widget _buildGreetingText() {
    return Consumer<UserModel?>(
      builder: (context, userModel, _) {
        if (userModel != null && userModel.displayName != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Greeting.showGreetings()},',
                style: kFontH6.copyWith(color: kBlue),
              ),
              Text(
                userModel.displayName ?? '',
                style: kFontH6,
              )
            ],
          );
        }
        return Text(
          Greeting.showGreetings(),
          style: kFontH6.copyWith(color: kBlue),
        );
      },
    );
  }
}
