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
    Widget child = const Icon(
      kAvatarIcon,
      color: kBlack,
    );
    ImageProvider? backgoundImage;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<UserModel?>(
          stream: CloudFire().getUserStream(id: widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              child = Container();
              // set the background image to the profile pic
              if (snapshot.data?.photoURL != null) {
                backgoundImage = CachedNetworkImageProvider(
                  snapshot.data!.photoURL!,
                );
              }
            }
            return CircleAvatar(
              radius: 14,
              backgroundImage: backgoundImage,
              child: child,
              backgroundColor: kGreyLight,
            );
          },
        ),
        const SizedBox(width: kContentSpacing8),
        Padding(
          padding: const EdgeInsets.only(top: kContentSpacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.displayName,
                style: kFontBody2.copyWith(
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
                style: kFontCaption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
