import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      alignment: Alignment.centerLeft,
      // padding: EdgeInsets.zero,
      radius: 0,
      child: const Icon(
        BootstrapIcons.chevron_left,
        color: kBlack,
        size: 28,
      ),
      onPressed: onPressed ?? () => Navigator.pop(context),
    );
  }
}
