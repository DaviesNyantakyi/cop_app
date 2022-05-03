import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../utilities/constant.dart';

Future<dynamic> showCustomBottomSheet({
  required BuildContext context,
  bool showHeader = true,
  bool isDismissable = true,
  Color backgroundColor = kWhite,
  required Widget child,
}) async {
  return showSlidingBottomSheet(
    context,
    builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: kRadius,
        avoidStatusBar: true,
        isDismissable: isDismissable,
        duration: const Duration(milliseconds: 400),
        color: backgroundColor,
        headerBuilder: showHeader
            ? (context, state) {
                return Container(
                  margin: const EdgeInsets.all(kContentSpacing8),
                  width: 40,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(kRadius),
                    ),
                  ),
                );
              }
            : null,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.5, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kContentSpacing16),
              child: Material(
                color: backgroundColor,
                child: child,
              ),
            ),
          );
        },
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
              p: kFontBody,
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
