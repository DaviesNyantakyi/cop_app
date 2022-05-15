import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class PodcastImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const PodcastImage({
    Key? key,
    required this.imageUrl,
    this.width = 160,
    this.height = 240,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: kGreyLight,
        borderRadius: const BorderRadius.all(
          Radius.circular(kRadius),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
