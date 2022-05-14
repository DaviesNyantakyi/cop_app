import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error, normal }
dynamic kShowSnackbar({
  required BuildContext context,
  required SnackBarType type,
  required String message,
}) {
  Color? backgroundColor;
  Color textColor;
  switch (type) {
    case SnackBarType.error:
      backgroundColor = kRed;
      textColor = Colors.white;
      break;
    case SnackBarType.success:
      backgroundColor = kGreen;
      textColor = Colors.white;
      break;

    default:
      backgroundColor = kGrey;
      textColor = kBlack;
      break;
  }
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(kContentSpacing16),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 5),
      content: Text(
        message,
        style: kFontBody.copyWith(color: textColor),
      ),
    ),
  );
}
