import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/auth_wrapper.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/custom_track_shape.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 5
    ..indicatorWidget = kCircularProgressIndicator
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cop Belgium',
      theme: _theme,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<SignUpNotifier>(
            create: (conext) => SignUpNotifier(),
          )
        ],
        child: const AuthWrapper(),
      ),
    );
  }
}

ThemeData _theme = ThemeData(
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kBlue,
  ),
  listTileTheme: const ListTileThemeData(tileColor: kWhite),
  dividerTheme: const DividerThemeData(thickness: 1),
  iconTheme: const IconThemeData(
    color: kBlack,
    size: kIconSize,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 2,
    shadowColor: kGreyWhite,
    iconTheme: IconThemeData(
      size: kIconSize,
      color: kBlack,
    ),
    backgroundColor: Colors.white,
    titleTextStyle: kFontH6,
  ),
  snackBarTheme: const SnackBarThemeData(elevation: kElevation),
  cardTheme: const CardTheme(
    elevation: 3,
    shadowColor: kGreyWhite,
    shape: RoundedRectangleBorder(
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
    color: kBlack,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: kBlue,
    thumbColor: kBlue,
    inactiveTrackColor: kGrey,
    trackShape: CustomTrackShape(),
  ),
);
