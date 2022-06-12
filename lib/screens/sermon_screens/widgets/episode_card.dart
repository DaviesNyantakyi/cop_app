import 'package:cop_belgium_app/models/episodes_model.dart';
import 'package:cop_belgium_app/screens/sermon_screens/widgets/sermon_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EpisodeCard extends StatefulWidget {
  final EpisodeModel episodeModel;
  final VoidCallback onPressed;
  const EpisodeCard(
      {Key? key, required this.episodeModel, required this.onPressed})
      : super(key: key);

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Container(
          height: 170,
          decoration: BoxDecoration(
            color: kWhite,
            boxShadow: [customBoxShadow],
            borderRadius: const BorderRadius.all(
              Radius.circular(kRadius),
            ),
          ),
          width: double.infinity,
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
            onPressed: widget.onPressed,
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
      child: SermonImage(
        width: size,
        imageUrl: widget.episodeModel.imageURL,
      ),
    );
  }

  Widget _buildDetails() {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.episodeModel.title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: kContentSpacing4),
          Text(
            widget.episodeModel.description,
            style: Theme.of(context).textTheme.bodyText2,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: kContentSpacing20,
          ),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: kBlack,
              ),
              const SizedBox(
                width: kContentSpacing4,
              ),
              Text(
                FormalDates.episodeDuration(
                  duration: widget.episodeModel.duration,
                ),
                style: Theme.of(context).textTheme.bodyText2,
              )
            ],
          )
        ],
      ),
    );
  }
}
