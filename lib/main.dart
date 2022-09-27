import 'package:cop_belgium_app/models/episode_model.dart';
import 'package:cop_belgium_app/models/podcast_model.dart';
import 'package:cop_belgium_app/providers/audio_provider.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/screens/auth_screens/auth_wrapper.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/custome_theme.dart';
import 'package:cop_belgium_app/widgets/circular_progress_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:feedback/feedback.dart';

Future<void> main() async {
  await _init();
  runApp(const MyApp());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();

  // To turn off landscape mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(PodcastModelAdapter());
  Hive.registerAdapter(EpisodeModelAdapter());
  await Hive.openBox<PodcastModel>('podcasts');
  await Hive.openBox<PodcastModel>('podcastSubscriptions');
  await Hive.openBox<EpisodeModel>('episodeDownloads');

  await initAudioSerivce();

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
    return BetterFeedback(
      theme: FeedbackThemeData(
        background: kGrey,
        feedbackSheetColor: kWhite,
        bottomSheetDescriptionStyle: Theme.of(context).textTheme.bodyText1!,
        drawColors: [
          kRed,
          kGreen,
          kBlue,
          kYellow,
        ],
      ),
      child: MaterialApp(
        title: 'COP Belgium',
        theme: CustomeTheme().theme(context: context),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<SignUpProvider>(
              create: (conext) => SignUpProvider(),
            ),
            ChangeNotifierProvider<AudioProvider>.value(
              value: AudioProvider(),
            ),
          ],
          child: const AuthWrapper(),
        ),
      ),
    );
  }
}
