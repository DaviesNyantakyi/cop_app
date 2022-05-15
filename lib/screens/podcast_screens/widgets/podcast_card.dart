import 'package:cop_belgium_app/screens/podcast_screens/widgets/podcast_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/cupertino.dart';

class PodcastCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onPressed;
  const PodcastCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          PodcastImage(
            imageUrl: imageUrl,
          ),
          const SizedBox(height: kContentSpacing8),
          Text(
            title,
            style: kFontBody,
          ),
        ],
      ),
      onTap: onPressed,
    );
  }
}
