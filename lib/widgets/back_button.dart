import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      radius: 0,
      child: const Icon(
        Icons.chevron_left,
        color: kBlack,
        size: 42,
      ),
      onPressed: onPressed,
    );
  }
}
