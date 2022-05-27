import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/cupertino.dart';

Future<void> nextPage({required PageController controller}) async {
  controller.nextPage(
    duration: kPagViewDuration,
    curve: kPagViewCurve,
  );
}

Future<void> previousPage({required PageController pageContoller}) async {
  pageContoller.previousPage(
    duration: kPagViewDuration,
    curve: kPagViewCurve,
  );
}
