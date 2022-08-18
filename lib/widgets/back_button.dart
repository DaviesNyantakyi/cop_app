import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(
        BootstrapIcons.chevron_left,
        color: kBlack,
        size: 28,
      ),
      onPressed: onPressed ?? () => Navigator.pop(context),
    );
  }
}
