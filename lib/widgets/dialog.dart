import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

Future<String?> showCustomDialog({
  required BuildContext context,
  required Widget title,
  Widget? actions,
  bool barrierDismissible = true,
}) async {
  return await showDialog<String?>(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) => Dialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(kRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(kContentSpacing16),
            child: title,
          ),
          actions != null ? const Divider() : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16)
                .copyWith(
              bottom: kContentSpacing8,
            ),
            child: SizedBox(
              height: 42,
              child: actions ?? Container(),
            ),
          )
        ],
      ),
    ),
  );
}
