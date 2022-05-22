import 'package:cop_belgium_app/screens/podcast_screens/podcast_player_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/widgets/episode_card.dart';
import 'package:cop_belgium_app/screens/podcast_screens/widgets/podcast_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PodcastDetailScreen extends StatefulWidget {
  const PodcastDetailScreen({Key? key}) : super(key: key);

  @override
  State<PodcastDetailScreen> createState() => _PodcastDetailScreenState();
}

class _PodcastDetailScreenState extends State<PodcastDetailScreen> {
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
              const EpisodeCard(),
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
    return const ExpandableText(
      paragrapgh,
      expandText: 'show more',
      collapseText: 'show less',
      maxLines: 4,
      linkColor: kBlue,
      style: kFontBody,
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
            _buildImageAndAuthor(),
            const SizedBox(height: kContentSpacing16),
            _buildSubscribeButton()
          ],
        );
      },
    );
  }

  Widget _buildImageAndAuthor() {
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
    return PodcastImage(
      imageUrl: unsplash,
      height: size,
      width: size,
    );
  }

  Widget _buildTitleAuthor() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        double? titleFontSize = kFontH5.fontSize;

        if (screenInfo.isWatch) {
          titleFontSize = kFontBody.fontSize;
        }
        if (screenInfo.isWatch) {
          titleFontSize = kFontBody.fontSize;
        }
        return Padding(
          padding: const EdgeInsets.only(top: kContentSpacing8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // style: podcast!.title.length > 40 ? kSFBodyBold : kSFHeadLine2,
              Text(
                'Deep Thruths',
                style: kFontH5.copyWith(
                  fontWeight: kFontWeightMedium,
                  fontSize: titleFontSize,
                ),
              ),
              const SizedBox(height: kContentSpacing4),
              // style: podcast!.title.length > 40 ? kSFBody2 : kSFBody,

              const Text(
                'Church of Pentecost Belgium',
                style: kFontBody2,
              ),
            ],
          ),
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
          style: kFontBody.copyWith(color: subscribed ? kWhite : kBlack),
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
