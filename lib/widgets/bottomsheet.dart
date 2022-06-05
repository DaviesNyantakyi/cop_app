import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../utilities/constant.dart';

Future<dynamic> showCustomBottomSheet({
  required BuildContext context,
  bool isDismissible = true,
  double? height,
  bool enableDrag = true,
  bool isScrollControlled = true,
  Color backgroundColor = kWhite,
  required Widget child,
}) async {
  return showModalBottomSheet(
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: backgroundColor,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(kRadius),
      ),
    ),
    context: context,
    builder: (context) {
      return SizedBox(
        height: height ?? MediaQuery.of(context).size.height * 0.85,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kContentSpacing16),
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(kRadius),
                topRight: Radius.circular(kRadius),
              ),
              color: backgroundColor,
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      );
    },
  );
}

void loadMdFile({required BuildContext context, required String mdFile}) {
  FocusScope.of(context).unfocus();

  showCustomBottomSheet(
    context: context,
    child: FutureBuilder(
      future: rootBundle.loadString(mdFile),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return MarkdownBody(
            styleSheet: MarkdownStyleSheet(
              p: Theme.of(context).textTheme.bodyText1,
            ),
            data: snapshot.data!,
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ),
  );
}
