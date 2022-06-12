import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';

import 'package:flutter/material.dart';

class SocialCard extends StatefulWidget {
  final Widget? body;
  final Widget avatar;

  final Widget? footer;
  final VoidCallback? onPressed;
  final List<PopupMenuEntry<String>>? menuItems;
  final Function(String)? onSelectMenuItem;

  const SocialCard({
    Key? key,
    this.body,
    this.footer,
    this.onPressed,
    this.menuItems,
    this.onSelectMenuItem,
    required this.avatar,
  }) : super(key: key);

  @override
  State<SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<SocialCard> {
  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 220,
        ),
        child: Container(
          height: null,
          padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16)
              .copyWith(
            top: kContentSpacing16,
            bottom: kContentSpacing8,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
            color: kWhite,
            boxShadow: [customBoxShadow],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: kContentSpacing12),
              widget.body ?? Container(),
              const SizedBox(height: kContentSpacing12),
              widget.footer ?? Container(),
            ],
          ),
        ),
      ),
      onPressed: widget.onPressed,
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.avatar,
        widget.menuItems?.length == null
            ? Container()
            : CustomElevatedButton(
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
                  itemBuilder: (BuildContext context) => widget.menuItems ?? [],
                ),
              )
      ],
    );
  }
}

/*

class SocialCard extends StatefulWidget {
  final List<Widget>? footer;

  final SocialAvatar socialAvatar;

  final List<PopupMenuEntry<String>>? menuItems;
  final Function(String)? onSelectMenuItem;
  final String description;

  final VoidCallback? onPressedCard;

  const SocialCard({
    Key? key,
    this.footer,
    this.onPressedCard,
    this.menuItems,
    this.onSelectMenuItem,
    required this.description,
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
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 202,
          minHeight: 202,
        ),
        child: Container(
          height: null,
          padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16)
              .copyWith(
            top: kContentSpacing16,
            bottom: kContentSpacing8,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(kRadius)),
            color: kWhite,
            boxShadow: [
              BoxShadow(
                color: kGreyLight,
                offset: kBoxShadowOffset,
                blurRadius: kElevation,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: kContentSpacing8),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyText1,
                maxLines: 4,
              ),
              const SizedBox(height: kContentSpacing12),
              _buildFooter(),
            ],
          ),
        ),
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
}*/
