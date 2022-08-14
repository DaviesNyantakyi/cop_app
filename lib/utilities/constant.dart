import 'package:flutter/material.dart';

// Other
const double kRadius = 7.0;
const double kBoderWidth = 1.5;
const double kButtonHeight = 58.0;
const double kIconSize = 24;
const double kElevation = 8.0;

BoxShadow customBoxShadow = BoxShadow(
  color: kGrey.withOpacity(0.2),
  offset: kBoxShadowOffset,
  blurRadius: kElevation,
);

// The angle of the shadow
const Offset kBoxShadowOffset = Offset(0, 4);

// 67% precentage of the screen
const kBottomsheetHeight = 0.84;

Duration kPagViewDuration = const Duration(milliseconds: 800);
Curve kPagViewCurve = Curves.easeOutExpo;

DateTime kMaxDate = DateTime(2050, 12, 31);
DateTime kMinDate = DateTime(1900, 01, 31);

// Color
const kWhite = Color(0xFFFFFFFF);
const kBlack = Color(0xFF000000);

const kGrey = Color(0xFF8D9091);
const kGreyLight = Color(0xFFEFEFEF);

const kBlue = Color(0xFF292FE9);
const kGreen = Color(0xFF00B86B);
const kYellow = Color(0xFFFFC145);
const kRed = Color(0xFFFF3B3B);

// Content Spacing
const double kContentSpacing4 = 4;
const double kContentSpacing8 = 8;
const double kContentSpacing12 = 12;
const double kContentSpacing16 = 16;
const double kContentSpacing20 = 20;
const double kContentSpacing24 = 24;
const double kContentSpacing32 = 32;
const double kContentSpacing40 = 40;
const double kContentSpacing64 = 64;
const double kContentSpacing128 = 128;
