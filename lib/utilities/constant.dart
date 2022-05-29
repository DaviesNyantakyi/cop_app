import 'package:flutter/material.dart';

// Other
const double kRadius = 10.0;
const double kBoderWidth = 1.5;
const double kButtonHeight = 60.0;
const double kIconSize = 24;
const double kElevation = 8.0;

const Offset kCardOffset = Offset(0, 4);

const kAvatarIcon = Icons.person_outline_rounded;

const kBottomsheetHeight = 0.67; // 67% precentage of the screen

Duration kPagViewDuration = const Duration(milliseconds: 800);
Curve kPagViewCurve = Curves.easeOutExpo;

DateTime kMaxDate = DateTime(2050, 12, 31);
DateTime kMinDate = DateTime(1900, 01, 31);

// Color
const kWhite = Color(0xFFFFFFFF);
const kBlack = Color(0xFF000000);

const kGreyWhite = Color(0xFFFBFBFB);
const kGreyLight = Color(0xFFEFEFEF);
const kGrey = Color(0xFF8D9091);

const kBlue = Color(0xFF292FE9);
const kGreen = Color(0xFF00B86B);
const kYellow = Color(0xFFFFC145);
const kRed = Color(0xFFFF3B3B);
const kShadowCOlor = kGreyWhite;

// Content Spacing
const double kContentSpacing4 = 4;
const double kContentSpacing8 = 8;
const double kContentSpacing12 = 12;
const double kContentSpacing16 = 16;
const double kContentSpacing20 = 20;
const double kContentSpacing24 = 24;
const double kContentSpacing32 = 32;
const double kContentSpacing64 = 64;
const double kContentSpacing128 = 128;

// Font
const String _sfDisplayFont = 'SFDisplay';
const kFontWeightMedium = FontWeight.w500;

const kFontH4 = TextStyle(
  fontSize: 34,
  color: kBlack,
  fontFamily: _sfDisplayFont,
);
const kFontH5 = TextStyle(
  fontSize: 24,
  color: kBlack,
  fontFamily: _sfDisplayFont,
);

const kFontH6 = TextStyle(
  fontSize: 20,
  color: kBlack,
  fontFamily: _sfDisplayFont,
);

const kFontBody = TextStyle(
  color: kBlack,
  fontSize: 16,
  fontFamily: _sfDisplayFont,
);

const kFontBody2 = TextStyle(
  color: kBlack,
  fontSize: 14,
  fontFamily: _sfDisplayFont,
);

const kFontCaption = TextStyle(
  color: kBlack,
  fontSize: 12,
  fontFamily: _sfDisplayFont,
);
