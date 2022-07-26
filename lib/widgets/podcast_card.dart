import 'package:cop_belgium_app/widgets/podcast_image.dart';
import 'package:flutter/material.dart';

import '../models/podcast_model.dart';

class PodcastCard extends StatelessWidget {
  final PodcastModel podcast;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  const PodcastCard({
    Key? key,
    required this.podcast,
    this.onTap,
    this.height = 120,
    this.width = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PodcastImage(
              height: height,
              width: width,
              imageURL: podcast.image ?? '',
            ),
            const SizedBox(height: 8),
            Text(
              podcast.title ?? '',
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              podcast.author ?? '',
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
