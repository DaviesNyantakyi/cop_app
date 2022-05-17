import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/models/testimony_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_player_screen.dart';
import 'package:cop_belgium_app/screens/testimonies_screens/edit_testimony_screen.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/dialog.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TestimonyCard extends StatefulWidget {
  final TestimonyModel testimony;
  const TestimonyCard({Key? key, required this.testimony}) : super(key: key);

  @override
  State<TestimonyCard> createState() => _TestimonyCardState();
}

class _TestimonyCardState extends State<TestimonyCard> {
  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  void onSelected(String? selectedValue) {
    if (selectedValue == 'edit') {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              EditTestimonyScreen(testimonyModel: widget.testimony),
        ),
      );
    }
    if (selectedValue == 'delete') {
      showDeleteDialog();
    }
  }

  Future<void> delete() async {
    try {
      Navigator.pop(context);
      EasyLoading.show();
      final result = await CloudFire().deleteTestimony(
        testimony: widget.testimony,
      );
      if (result == true) {}
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> showDeleteDialog() async {
    showCustomDialog(
      context: context,
      title: const Text(
        'Delete testimony?',
        style: kFontBody,
      ),
      actions: [
        CustomElevatedButton(
          padding: EdgeInsets.zero,
          child: const Text(
            'Cancel',
            style: kFontBody,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CustomElevatedButton(
          child: Text(
            'Delete',
            style: kFontBody.copyWith(color: kRed),
          ),
          onPressed: delete,
        )
      ],
    );
  }

  showTestimonyBottomSheet() {
    showCustomBottomSheet(
      initialSnap: 1,
      snappings: [1],
      context: context,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: kContentSpacing8),
                  _buildNameAndDate(),
                ],
              ),
              const SizedBox(
                height: kContentSpacing24,
              ),
              Text(
                widget.testimony.title,
                style: kFontBody.copyWith(fontWeight: kFontWeightMedium),
              ),
              const SizedBox(
                height: kContentSpacing8,
              ),
              Text(
                widget.testimony.testimony,
                style: kFontBody,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      height: null,
      backgroundColor: kGreyLight,
      padding: const EdgeInsets.all(kContentSpacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: kContentSpacing8),
          _buildTestimony(),
        ],
      ),
      onPressed: showTestimonyBottomSheet,
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: kContentSpacing8),
            _buildNameAndDate(),
          ],
        ),
        _buildMoreButton(),
      ],
    );
  }

  Widget _buildTestimony() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.testimony.title,
          maxLines: 1,
          style: kFontBody.copyWith(fontWeight: kFontWeightMedium),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: kContentSpacing4),
        Text(
          widget.testimony.testimony,
          maxLines: 3,
          style: kFontBody,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void ontap() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditTestimonyScreen(
          testimonyModel: widget.testimony,
        ),
      ),
    );
  }

  Flexible _buildMoreButton() {
    return Flexible(
      child: CustomElevatedButton(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: () {
          popupMenuKey.currentState?.showButtonMenu();
        },
        child: PopupMenuButton<String>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kRadius),
            ),
          ),
          key: popupMenuKey,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'edit',
              child: const Text('Edit', style: kFontBody),
              onTap: () {},
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: kFontBody.copyWith(color: kRed)),
              onTap: () {},
            ),
          ],
          child: const Icon(
            Icons.more_vert_rounded,
            color: kBlack,
            size: 20,
          ),
          onSelected: onSelected,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    // set the avatar icon when the background image is null
    Widget child = const Icon(
      kAvatarIcon,
      color: kBlack,
    );
    ImageProvider? backgoundImage;

    return StreamBuilder<UserModel?>(
      stream: CloudFire().getUserStream(id: widget.testimony.userId),
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
    );
  }

  Padding _buildNameAndDate() {
    return Padding(
      padding: const EdgeInsets.only(top: kContentSpacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.testimony.displayName ?? '',
            style: kFontBody2.copyWith(
              fontWeight: kFontWeightMedium,
            ),
          ),
          Text(
            FormalDates.formatDmyyyyHm(
                  date: DateTime.fromMillisecondsSinceEpoch(
                    widget.testimony.date.millisecondsSinceEpoch,
                  ),
                ) ??
                '',
            style: kFontCaption,
          ),
        ],
      ),
    );
  }
}
