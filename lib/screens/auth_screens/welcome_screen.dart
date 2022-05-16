import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_in_screen.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/signup_flow.dart';

import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/cop_logo.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SignUpNotifier signUpNotifier;

  Future<void> continueWithGoogle() async {
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

  Future<void> continueWithApple() async {}

  Future<void> continueWithEmail() async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<SignUpNotifier>.value(
              value: signUpNotifier,
            ),
          ],
          child: const SignUpFlow(),
        ),
      ),
    );
  }

  void signIn() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<SignUpNotifier>.value(
              value: signUpNotifier,
            ),
          ],
          child: const SignInScreen(),
        ),
      ),
    );
  }

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    signUpNotifier.resetForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenInfo.screenSize.width >= kScreenSizeTablet
                      ? kContentSpacing64
                      : kContentSpacing16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    screenInfo.screenSize.width < kScreenSizeMobile
                        ? const SizedBox(height: kContentSpacing32)
                        : const SizedBox(height: kContentSpacing64),
                    _buildHeader(),
                    screenInfo.screenSize.width < kScreenSizeMobile
                        ? const SizedBox(height: kContentSpacing32)
                        : const SizedBox(height: kContentSpacing32),
                    _buildGoogleButton(),
                    const SizedBox(height: kContentSpacing8),
                    _buildAppleButton(),
                    const SizedBox(height: kContentSpacing8),
                    _buildEmailButton(context: context),
                    screenInfo.screenSize.width < kScreenSizeMobile
                        ? const SizedBox(height: kContentSpacing16)
                        : const SizedBox(height: kContentSpacing20),
                    _buildSignInButton(),
                    screenInfo.screenSize.width < kScreenSizeMobile
                        ? const SizedBox(height: kContentSpacing12)
                        : const SizedBox(height: kContentSpacing20),
                    _buildSkipButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Column(
          children: [
            screenInfo.screenSize.width < kScreenSizeMobile
                ? Container()
                : const CopLogo(
                    width: 100,
                    height: 100,
                  ),
            screenInfo.screenSize.width < kScreenSizeMobile
                ? Container()
                : const SizedBox(height: kContentSpacing20),
            Text(
              'Church of Pentecost Belgium',
              style: screenInfo.screenSize.width <= kScreenSizeMobile
                  ? kFontBody.copyWith(
                      color: kBlue,
                      fontWeight: kFontWeightMedium,
                    )
                  : kFontBody.copyWith(
                      color: kBlue,
                      fontWeight: kFontWeightMedium,
                    ),
            ),
            Text(
              'Welcome',
              style: screenInfo.screenSize.width <= kScreenSizeMobile
                  ? kFontBody.copyWith(
                      color: kBlue,
                      fontWeight: kFontWeightMedium,
                    )
                  : kFontBody.copyWith(
                      color: kBlue,
                      fontWeight: kFontWeightMedium,
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoogleButton() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return SocialButton(
          icon: screenInfo.screenSize.width <= kScreenSizeMobile
              ? Container()
              : const Icon(
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
          onPressed: continueWithGoogle,
        );
      },
    );
  }

  Widget _buildAppleButton() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return SocialButton(
          backgroundColor: kBlack,
          icon: screenInfo.screenSize.width <= kScreenSizeMobile
              ? Container()
              : const Icon(
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
          onPressed: continueWithApple,
        );
      },
    );
  }

  Widget _buildEmailButton({required BuildContext context}) {
    return CustomElevatedButton(
      side: const BorderSide(width: kBoderWidth, color: kBlack),
      child: Text(
        'Continue with Email',
        style: kFontBody.copyWith(
          fontWeight: FontWeight.bold,
          color: kBlack,
        ),
      ),
      onPressed: continueWithEmail,
    );
  }

  Widget _buildSignInButton() {
    return CustomElevatedButton(
      height: null,
      splashColor: Colors.transparent,
      onPressed: signIn,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Already have an account? ',
              style: kFontBody,
            ),
            Text(
              'Sign in',
              style: kFontBody.copyWith(
                color: kBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomElevatedButton _buildSkipButton() {
    return CustomElevatedButton(
      height: null,
      splashColor: Colors.transparent,
      child: Text(
        'Skip for now',
        style: kFontBody.copyWith(color: kGrey),
      ),
      onPressed: () {},
    );
  }
}
