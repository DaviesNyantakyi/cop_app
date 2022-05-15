import 'package:cop_belgium_app/screens/podcast_screens/podcast_player_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/widgets/podcast_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EpisodeCard extends StatefulWidget {
  const EpisodeCard({
    Key? key,
  }) : super(key: key);

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return SizedBox(
          height: 170,
          width: double.infinity,
          child: Card(
            child: CustomElevatedButton(
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(kContentSpacing8),
                child: Row(
                  children: [
                    _buildImage(screenInfo: screenInfo),
                    const SizedBox(width: kContentSpacing12),
                    _buildDetails(),
                  ],
                ),
              ),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage({required SizingInformation screenInfo}) {
    double size = 140;

    if (screenInfo.isWatch) {
      return Container();
    }

    return Flexible(
      flex: 5,
      child: PodcastImage(
        width: size,
        imageUrl: unsplash,
      ),
    );
  }

  Widget _buildDetails() {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            paragrapgh,
            style: kFontBody.copyWith(
              fontWeight: kFontWeightMedium,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: kContentSpacing4),
          const Text(
            paragrapgh,
            style: kFontBody2,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: kContentSpacing20,
          ),
          Row(
            children: const [
              Icon(
                Icons.schedule_rounded,
                color: kBlack,
              ),
              SizedBox(
                width: kContentSpacing4,
              ),
              Text(
                '23:00',
                style: kFontBody2,
              )
            ],
          )
        ],
      ),
    );
  }
}
