import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_screens/signup_page_screen.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/cop_logo.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> loginGoogle() async {
    FireAuth fireAuth = FireAuth();
    try {
      EasyLoading.show();
      await fireAuth.loginGoogle();
    } on FirebaseException catch (e) {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kContentSpacing16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: kContentSpacing64),
                _buildGoogleButton(),
                const SizedBox(height: kContentSpacing8),
                _buildAppleButton(),
                const SizedBox(height: kContentSpacing8),
                _buildEmailButton(context: context),
                const SizedBox(height: kContentSpacing32),
                _buildLoginButton(),
                const SizedBox(height: kContentSpacing32),
                _buildSkipButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      children: [
        const CopLogo(),
        const SizedBox(height: kContentSpacing20),
        Text(
          'Church of Pentecost Belgium',
          style: kFontBody.copyWith(
            color: kBlue,
            fontWeight: kFontWeightMedium,
          ),
        ),
        Text(
          'Welcome',
          style: kFontBody.copyWith(
            fontWeight: kFontWeightMedium,
          ),
        ),
      ],
    );
  }

  SocialButton _buildGoogleButton() {
    return SocialButton(
      width: double.infinity,
      icon: const Icon(
        FontAwesomeIcons.google,
        size: 30,
        color: kWhite,
      ),
      label: Text(
        'Continue with Google',
        style: kFontBody.copyWith(
          fontWeight: FontWeight.bold,
          color: kWhite,
        ),
      ),
      onPressed: loginGoogle,
    );
  }

  SocialButton _buildAppleButton() {
    return SocialButton(
      backgroundColor: kBlack,
      width: double.infinity,
      icon: const Icon(
        FontAwesomeIcons.apple,
        size: 32,
        color: kWhite,
      ),
      label: Text(
        'Continue with Apple',
        style: kFontBody.copyWith(
          fontWeight: FontWeight.bold,
          color: kWhite,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildEmailButton({required BuildContext context}) {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          side: const BorderSide(width: kBoderWidth, color: kBlack),
          width: double.infinity,
          child: Text(
            'Continue with Email',
            style: kFontBody.copyWith(
              fontWeight: FontWeight.bold,
              color: kBlack,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider<SignUpNotifier>.value(
                      value: signUpNotifier,
                    ),
                  ],
                  child: const SignUpPageScreen(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  CustomElevatedButton _buildLoginButton() {
    return CustomElevatedButton(
      height: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Already have an account? ',
            style: kFontBody.copyWith(),
          ),
          Text(
            'Login',
            style: kFontBody.copyWith(
              color: kBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  CustomElevatedButton _buildSkipButton() {
    return CustomElevatedButton(
      height: null,
      child: Text(
        'Skip for now',
        style: kFontBody.copyWith(color: kGrey),
      ),
      onPressed: () {},
    );
  }
}
