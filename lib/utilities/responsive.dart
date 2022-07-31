// import 'package:cop_belgium_app/utilities/constant.dart';
// import 'package:responsive_builder/responsive_builder.dart';

import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:responsive_builder/responsive_builder.dart';

const kScreenSmall = 300;
const kScreenMoible = 380;
const kScreenTablet = 480;
const kScreenDesktop = 860;

int crossAxisCount(SizingInformation screenInfo) {
  if (screenInfo.isDesktop) {
    return 4;
  }
  if (screenInfo.isTablet) {
    return 3;
  }

  if (screenInfo.isWatch) {
    return 1;
  }
  return 2;
}

double crossAxisSpacing(SizingInformation screenInfo) {
  if (screenInfo.isDesktop) {
    return kContentSpacing12;
  }
  if (screenInfo.isTablet) {
    return kContentSpacing12;
  }

  if (screenInfo.isWatch) {
    return kContentSpacing8;
  }
  return kContentSpacing8;
}
