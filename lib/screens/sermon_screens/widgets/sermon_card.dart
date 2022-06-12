import 'package:cop_belgium_app/screens/sermon_screens/widgets/sermon_image.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class SermonCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onPressed;
  const SermonCard({
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
          SermonImage(
            imageUrl: imageUrl,
            height: 210,
            width: 200,
          ),
          const SizedBox(height: kContentSpacing8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      onTap: onPressed,
    );
  }
}
