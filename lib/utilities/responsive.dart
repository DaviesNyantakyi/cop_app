import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:responsive_builder/responsive_builder.dart';

const kScreenSizeMobile = 320;
const kScreenSizeTablet = 480;
const kScreenSizeDesktop = 860;
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

double horizontalPadding(SizingInformation screenInfo) {
  if (screenInfo.isDesktop) {
    return kContentSpacing32;
  }
  if (screenInfo.isTablet) {
    return kContentSpacing24;
  }

  if (screenInfo.isWatch) {
    return kContentSpacing24;
  }
  return kContentSpacing16;
}

double gradSpacing(SizingInformation screenInfo) {
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
