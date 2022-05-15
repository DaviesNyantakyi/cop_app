import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

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
