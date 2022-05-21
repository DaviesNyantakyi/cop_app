import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/social_avatar.dart';

import 'package:flutter/material.dart';

class SocialCard extends StatefulWidget {
  final List<Widget>? footer;

  final SocialAvatar socialAvatar;

  final List<PopupMenuEntry<String>>? menuItems;
  final Function(String)? onSelectMenuItem;
  final Widget content;

  final VoidCallback? onPressedCard;

  const SocialCard({
    Key? key,
    this.footer,
    this.onPressedCard,
    this.menuItems,
    this.onSelectMenuItem,
    required this.content,
    required this.socialAvatar,
  }) : super(key: key);

  @override
  State<SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<SocialCard> {
  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      height: null,
      backgroundColor: kGreyLight,
      padding: widget.footer == null || widget.footer?.isEmpty == true
          ? const EdgeInsets.all(kContentSpacing16)
          : const EdgeInsets.symmetric(horizontal: kContentSpacing16).copyWith(
              top: kContentSpacing16,
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: kContentSpacing8),
          widget.content,
          const SizedBox(width: kContentSpacing12),
          _buildFooter(),
        ],
      ),
      onPressed: widget.onPressedCard,
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.socialAvatar,
        _buildMenuItemButton(),
      ],
    );
  }

  Widget _buildMenuItemButton() {
    // ignore: prefer_is_empty
    if (widget.menuItems == null || widget.menuItems?.length == 0) {
      return Container();
    }
    return CustomElevatedButton(
      width: 42,
      height: 42,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      onPressed: () {
        popupMenuKey.currentState?.showButtonMenu();
      },
      child: PopupMenuButton<String>(
        onSelected: widget.onSelectMenuItem,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(kRadius),
          ),
        ),
        key: popupMenuKey,
        child: const Icon(
          Icons.more_vert_rounded,
          color: kBlack,
          size: 20,
        ),
        itemBuilder: (BuildContext context) => widget.menuItems!,
      ),
    );
  }

  Widget _buildFooter() {
    if (widget.footer != null) {
      return Row(
        children: widget.footer!,
      );
    }
    return Container();
  }
}



/*import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/models/testimony_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/testimonies_screens/edit_testimony_screen.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/dialog.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TestimonyCard extends StatefulWidget {
  final List<Widget>? footer;
  final TestimonyModel testimonyModel;

  final VoidCallback? onPressed;
  const TestimonyCard({
    Key? key,
    required this.testimonyModel,
    this.footer,
    this.onPressed,
  }) : super(key: key);

  @override
  State<TestimonyCard> createState() => _TestimonyCardState();
}

class _TestimonyCardState extends State<TestimonyCard> {
  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  Future<void> deleteTestimony() async {
    try {
      Navigator.pop(context);
      EasyLoading.show();
      await CloudFire().deleteTestimony(
        testimony: widget.testimonyModel,
      );
    } on FirebaseException catch (e) {
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
          onPressed: deleteTestimony,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      height: null,
      backgroundColor: kGreyLight,
      padding: widget.footer == null
          ? const EdgeInsets.all(kContentSpacing16)
          : const EdgeInsets.symmetric(horizontal: kContentSpacing16).copyWith(
              top: kContentSpacing16,
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: kContentSpacing8),
          _buildTestimony(),
          const SizedBox(width: kContentSpacing12),
          _buildFooter(),
        ],
      ),
      onPressed: widget.onPressed,
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAvatar(),
        _buildMoreButton(),
      ],
    );
  }

  Widget _buildMoreButton() {
    if (widget.testimonyModel.uid !=
        FirebaseAuth.instance.currentUser?.uid) {
      return Container();
    }
    return CustomElevatedButton(
      width: 42,
      height: 42,
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
        onSelected: (selectedValue) {
          if (selectedValue == 'edit') {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => EditTestimonyScreen(
                  testimonyModel: widget.testimonyModel,
                ),
              ),
            );
          }
          if (selectedValue == 'delete') {
            showDeleteDialog();
          }
        },
      ),
    );
  }

  Widget _buildFooter() {
    if (widget.footer != null) {
      return Row(
        children: widget.footer!,
      );
    }
    return Container();
  }

  Widget _buildTestimony() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.testimonyModel.title,
          maxLines: 1,
          style: kFontBody.copyWith(fontWeight: kFontWeightMedium),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: kContentSpacing4),
        Text(
          widget.testimonyModel.testimony,
          maxLines: 3,
          style: kFontBody,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    // set the avatar icon when the background image is null
    Widget child = const Icon(
      kAvatarIcon,
      color: kBlack,
    );
    ImageProvider? backgoundImage;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<UserModel?>(
          stream: CloudFire().getUserStream(id: widget.testimonyModel.uid),
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
        _buildNameAndDate(),
      ],
    );
  }

  Padding _buildNameAndDate() {
    return Padding(
      padding: const EdgeInsets.only(top: kContentSpacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.testimonyModel.displayName ?? '',
            style: kFontBody2.copyWith(
              fontWeight: kFontWeightMedium,
            ),
          ),
          Text(
            FormalDates.timeAgo(
                  date: DateTime.fromMillisecondsSinceEpoch(
                    widget.testimonyModel.date.millisecondsSinceEpoch,
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
 */