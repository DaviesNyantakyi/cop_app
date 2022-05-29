import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

Future<String?> showCustomDialog({
  required BuildContext context,
  Widget? title,
  Widget? content,
  List<Widget>? actions,
  bool barrierDismissible = true,
}) async {
  return await showDialog<String?>(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(kRadius),
        ),
      ),
      title: title,
      actionsPadding: const EdgeInsets.all(kContentSpacing8),
      content: content,
      actions: actions,
    ),
  );
}
