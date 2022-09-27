import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/track_shape.dart';
import 'package:flutter/material.dart';

class CustomeTheme {
  ThemeData theme({required BuildContext context}) {
    return ThemeData(
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kBlue,
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: kWhite,
        contentPadding: EdgeInsets.symmetric(horizontal: kContentSpacing16),
      ),
      dividerTheme: const DividerThemeData(thickness: 1),
      iconTheme: const IconThemeData(
        color: kBlack,
        size: kIconSize,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: kBlue,
        unselectedLabelColor: kBlack,
        labelStyle: Theme.of(context).textTheme.bodyText2,
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText2,
      ),
      appBarTheme: AppBarTheme(
        elevation: 2,
        shadowColor: customBoxShadow.color,
        iconTheme: const IconThemeData(
          size: kIconSize,
          color: kBlack,
        ),
        backgroundColor: Colors.white,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      snackBarTheme: const SnackBarThemeData(elevation: kElevation),
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: customBoxShadow.color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(kRadius),
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: kBlack,
        selectionHandleColor: kBlack,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kBlue,
      ),
      textTheme: const TextTheme(
        headline4: TextStyle(
          fontSize: 34,
          color: kBlack,
          fontWeight: FontWeight.normal,
        ),
        headline5: TextStyle(
          fontSize: 24,
          color: kBlack,
          fontWeight: FontWeight.normal,
        ),
        headline6: TextStyle(
          fontSize: 20,
          color: kBlack,
          fontWeight: FontWeight.normal,
        ),
        bodyText1: TextStyle(
          fontSize: 16,
          color: kBlack,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          color: kBlack,
          fontWeight: FontWeight.normal,
        ),
        caption: TextStyle(
          fontSize: 12,
          color: kBlack,
          fontWeight: FontWeight.normal,
        ),
      ),
      shadowColor: kGreyLight,
      sliderTheme: SliderThemeData(
        activeTrackColor: kBlue,
        thumbColor: kBlue,
        overlayColor: kBlue.withOpacity(0.1),
        inactiveTrackColor: kGreyLight,
        trackHeight: 4,
        trackShape: CustomSliderTrackShape(),
      ),
    );
  }
}
