import 'package:cop_belgium_app/models/episode_model.dart';
import 'package:cop_belgium_app/models/podcast_model.dart';
import 'package:cop_belgium_app/providers/audio_provider.dart';
import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/auth_wrapper.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/track_shape.dart';
import 'package:cop_belgium_app/widgets/circular_progress_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

late AudioProvider _audioProvider;

Future<void> main() async {
  await _init();
  runApp(const MyApp());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();

  Hive.registerAdapter(PodcastModelAdapter());
  Hive.registerAdapter(EpisodeModelAdapter());

  await Hive.openBox<PodcastModel>('podcasts');
  await Hive.openBox<PodcastModel>('subscriptions');
  await Hive.openBox<EpisodeModel>('downloads');

  _audioProvider = await initAudioSerivce();

  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    const ScreenBreakpoints(
      desktop: 860,
      tablet: 480,
      watch: 320, //small
    ),
  );
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 5
    ..indicatorWidget = const CustomCircularProgressIndicator()
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cop Belgium',
      theme: _theme(context: context),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<SignUpNotifier>(
            create: (conext) => SignUpNotifier(),
          ),
          ChangeNotifierProvider<AudioProvider>.value(
            value: _audioProvider,
          ),
        ],
        child: const AuthWrapper(),
      ),
    );
  }
}

ThemeData _theme({required BuildContext context}) {
  return ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kBlue,
    ),
    listTileTheme: const ListTileThemeData(tileColor: kWhite),
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
      inactiveTrackColor: kGreyLight,
      trackHeight: 4,
      overlayColor: kBlue.withOpacity(0.1),
      trackShape: CustomSliderTrackShape(),
    ),
  );
}
