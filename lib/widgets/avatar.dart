import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/cloud_fire.dart';
import '../utilities/constant.dart';

class CustomAvatar extends StatefulWidget {
  final double? radius;
  final double? iconSize;
  const CustomAvatar({Key? key, this.radius = 24, this.iconSize = 24})
      : super(key: key);

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  final _firebaseAuth = FirebaseAuth.instance;

  late final userStream = CloudFire().getUserStream(
    uid: _firebaseAuth.currentUser!.uid,
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: userStream,
      builder: (context, snapshot) {
        Widget child = Icon(
          Icons.person_outline_outlined,
          color: kBlack,
          size: widget.iconSize,
        );
        ImageProvider<Object>? backgroundImage;

        if (snapshot.hasData &&
            snapshot.data?.photoURL != null &&
            snapshot.data?.photoURL?.isEmpty == false) {
          backgroundImage = CachedNetworkImageProvider(
            snapshot.data!.photoURL!,
          );
          child = Container();
        }
        return CircleAvatar(
          radius: widget.radius,
          backgroundColor: kGreyLight,
          child: child,
          backgroundImage: backgroundImage,
        );
      },
    );
  }
}
