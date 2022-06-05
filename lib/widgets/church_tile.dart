import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../utilities/constant.dart';

const _cardHeight = 140.0;

class ChurchTile extends StatelessWidget {
  final VoidCallback onTap;
  final ChurchModel church;

  const ChurchTile({
    Key? key,
    required this.church,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      child: Card(
        child: CustomElevatedButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _BuildImage(church: church),
              _BuildAddress(church: church),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildImage extends StatelessWidget {
  const _BuildImage({
    Key? key,
    required this.church,
  }) : super(key: key);

  final ChurchModel church;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: kContentSpacing8).copyWith(
          left: kContentSpacing8,
          right: kContentSpacing12,
        ),
        height: _cardHeight,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
          color: kGreyLight,
          image: church.imageURL != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    church.imageURL!,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _BuildAddress extends StatelessWidget {
  const _BuildAddress({
    Key? key,
    required this.church,
  }) : super(key: key);

  final ChurchModel church;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: kContentSpacing8).copyWith(
          right: kContentSpacing8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              church.churchName,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: kFontWeightMedium),
            ),
            const SizedBox(height: kContentSpacing4),
            Text(
              church.address,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
