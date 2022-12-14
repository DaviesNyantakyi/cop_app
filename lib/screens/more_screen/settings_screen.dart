import 'dart:io';

import 'package:cop_belgium_app/screens/more_screen/account_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/load_markdown.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/cop_logo.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  static String settingsScreen = 'settingsScreen';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo? packageInfo;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // Device name
  // App version

  String? deviceModel;
  String? deviceManufacturer;
  String? packageVersion;

  Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }

  Future<void> sendFeedBack({
    required String type,
    required UserFeedback feedback,
  }) async {
    String? subject;
    String recipients = 'apkerooo@gmail.com';
    String appVersion = 'App version: $packageVersion';
    String? message;

    if (type == 'bug') {
      subject = 'Bug';
      message = 'Please write about your bug here:';
    } else {
      subject = 'App Feedback';
      message = 'Please write about your feedback here:';
    }

    final imagePath = await writeImageToStorage(feedback.screenshot);

    final Email mail = Email(
      subject: subject,
      body: '''
      $message
      ${feedback.text}


      Device Information: 
      $deviceManufacturer - $deviceModel
      $appVersion
      ''',
      recipients: [recipients],
      attachmentPaths: [imagePath],
    );

    try {
      await FlutterEmailSender.send(mail);
    } on PlatformException catch (e) {
      debugPrint(e.toString());

      if (e.message == 'No email clients found!') {
        launchUrl(Uri.parse(
            'mailto:$recipients?subject=${mail.subject}&body=${mail.body}'));
      }
    } catch (e) {
      debugPrint(e.toString());
      showCustomSnackBar(
        type: CustomSnackBarType.normal,
        context: context,
        message: e.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getAppInfo();
    await getDeviceInfo();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getAppInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    packageVersion = packageInfo?.version;
  }

  Future<void> getDeviceInfo() async {
    if (mounted) {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel = androidInfo.model;
        deviceManufacturer = androidInfo.manufacturer;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.model;
        deviceManufacturer = 'apple';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context: context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: kContentSpacing16),
          child: Center(
            child: Column(
              children: [
                _buildLogo(),
                const SizedBox(height: kContentSpacing12),
                _buildPackageVersion(),
                const SizedBox(height: 39),
                _buildAccounrTile(),
                _buildFeedBackTiles(),
                _buildPrivacyTiles(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const CopLogo(width: 100, height: 100);
  }

  Widget _buildFeedBackTiles() {
    return Column(
      children: [
        ListTile(
          onTap: () async {
            BetterFeedback.of(context).show((UserFeedback feedback) async {
              await sendFeedBack(type: 'bug', feedback: feedback);
            });
          },
          title: Text(
            'Report a Bug',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        ListTile(
          onTap: () async {
            BetterFeedback.of(context).show((UserFeedback feedback) async {
              await sendFeedBack(type: 'feedback', feedback: feedback);
            });
          },
          title: Text(
            'Send Feedback',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageVersion() {
    return Text(
      packageVersion != null ? ' v$packageVersion' : '',
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  Widget _buildPrivacyTiles() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Privacy Policy',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onTap: () {
            loadMarkdownFile(
              context: context,
              mdFile: 'assets/privacy/privacy_policy.md',
            );
          },
        ),
        ListTile(
          onTap: () {
            loadMarkdownFile(
              context: context,
              mdFile: 'assets/privacy/terms_of_service.md',
            );
          },
          title: Text(
            'Terms Of Service',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }

  Widget _buildAccounrTile() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Account',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const AccountScreen()));
          },
        ),
      ],
    );
  }

  dynamic _buildAppbar({required BuildContext context}) {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text(
        'Settings',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
