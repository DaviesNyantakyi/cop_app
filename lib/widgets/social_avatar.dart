import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:flutter/material.dart';

class SocialAvatar extends StatefulWidget {
  final Timestamp createdAt;
  final String uid;
  final String displayName;
  const SocialAvatar({
    Key? key,
    required this.createdAt,
    required this.uid,
    required this.displayName,
  }) : super(key: key);

  @override
  State<SocialAvatar> createState() => _SocialAvatarState();
}

class _SocialAvatarState extends State<SocialAvatar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatar(),
        const SizedBox(width: kContentSpacing8),
        _buildDateAndName(),
      ],
    );
  }

  Widget _buildAvatar() {
    Widget child = const Icon(
      Icons.person_outline_rounded,
      color: kBlack,
      size: 18,
    );
    ImageProvider? backgoundImage;
    return StreamBuilder<UserModel?>(
      stream: CloudFire().getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // set the background image to the profile pic
          if (snapshot.data?.photoURL != null) {
            backgoundImage = CachedNetworkImageProvider(
              snapshot.data!.photoURL!,
            );
          }
        }
        return CircleAvatar(
          radius: 18,
          backgroundImage: backgoundImage,
          child: child,
          backgroundColor: kGreyLight,
        );
      },
    );
  }

  Padding _buildDateAndName() {
    return Padding(
      padding: const EdgeInsets.only(top: kContentSpacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.displayName,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontWeight: kFontWeightMedium,
                ),
          ),
          Text(
            FormalDates.timeAgo(
                  date: DateTime.fromMillisecondsSinceEpoch(
                    widget.createdAt.millisecondsSinceEpoch,
                  ),
                ) ??
                '',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
