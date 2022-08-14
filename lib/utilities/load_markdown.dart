import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../widgets/bottomsheet.dart';

void loadMarkdownFile({
  required BuildContext context,
  required String mdFile,
}) async {
  FocusScope.of(context).unfocus();

  await showCustomBottomSheet(
    height: MediaQuery.of(context).size.height * kBottomsheetHeight,
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
