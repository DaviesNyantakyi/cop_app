import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class SermonImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final EdgeInsets? margin;

  const SermonImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.margin,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: kGreyLight,
        borderRadius: const BorderRadius.all(
          Radius.circular(kRadius),
        ),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
