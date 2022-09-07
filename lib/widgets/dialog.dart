import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  Widget? title,
  Widget? content,
  List<Widget>? actions,
  bool barrierDismissible = true,
}) async {
  await NDialog(
    dialogStyle: DialogStyle(
      titleDivider: true,
      contentTextStyle: Theme.of(context).textTheme.bodyText1,
      titleTextStyle: Theme.of(context).textTheme.headline6,
      contentPadding: const EdgeInsets.all(kContentSpacing16),
    ),
    title: title,
    content: content,
    actions: actions,
  ).show(context);
}
