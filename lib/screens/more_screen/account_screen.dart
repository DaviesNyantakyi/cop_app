import 'package:cop_belgium_app/screens/profile_screen/verify_account.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  PackageInfo? packageInfo;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String? deviceModel;
  String? deviceManufacturer;
  String? packageVersion;

  Future<void> sendFeedBack({required String type}) async {
    String? subject;
    String appVersion = 'App version: $packageVersion';
    String? message;

    if (type == 'bug') {
      subject = 'Bug';
      message = 'Please write about your bug here.';
    } else {
      subject = 'App Feedback';
      message = 'Please write about your feedback here.';
    }

    final Email email = Email(
      subject: subject,
      body: '''
      $message


      Device Information: 
      $deviceManufacturer - $deviceModel
      $appVersion
      ''',
      recipients: ['apkerooo@gmail.com'],
    );

    try {
      await FlutterEmailSender.send(email);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context: context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: kContentSpacing16),
          child: Center(
            child: Column(
              children: [
                _buildDeleteTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteTile() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Delete account',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const VerifyAccountScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  dynamic _buildAppbar({required BuildContext context}) {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text(
        'Account',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
