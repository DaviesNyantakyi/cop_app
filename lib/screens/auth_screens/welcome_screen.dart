import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_in_screen.dart';
import 'package:cop_belgium_app/screens/auth_screens/signup_page_view.dart';

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
  FireAuth fireAuth = FireAuth();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> continueWithGoogle() async {
    try {
      EasyLoading.show();
      await fireAuth.signInWithGoogle();
      EasyLoading.dismiss();
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
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
          child: const SignUpPageView(),
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

  Future<void> signInAnonymously() async {
    try {
      EasyLoading.show();

      await fireAuth.signInAnonymously();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());

      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Scaffold(
          appBar: _buildAppBar(),
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
                    const SizedBox(height: kContentSpacing32),
                    _buildImage(),
                    const SizedBox(height: kContentSpacing32),
                    _buildGoogleButton(),
                    const SizedBox(height: kContentSpacing8),
                    _buildAppleButton(),
                    const SizedBox(height: kContentSpacing8),
                    _buildEmailButton(context: context),
                    const SizedBox(height: kContentSpacing32),
                    _buildSignInButton(),
                    const SizedBox(height: kContentSpacing16),
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

  dynamic _buildAppBar() {
    if (firebaseAuth.currentUser?.isAnonymous == false ||
        firebaseAuth.currentUser == null) {
      return PreferredSize(child: Container(), preferredSize: const Size(0, 0));
    }
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 70,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        )
      ],
    );
  }

  Widget _buildImage() {
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
                  ? Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: kBlue,
                        fontWeight: kFontWeightMedium,
                      )
                  : Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: kBlue,
                        fontWeight: kFontWeightMedium,
                      ),
            ),
            FittedBox(
              child: Text(
                'Welcome',
                style: screenInfo.screenSize.width <= kScreenSizeMobile
                    ? Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: kBlue,
                          fontWeight: kFontWeightMedium,
                        )
                    : Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: kBlue,
                          fontWeight: kFontWeightMedium,
                        ),
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
        return CustomIconButton(
          height: kButtonHeight,
          leading: screenInfo.screenSize.width <= kScreenSizeMobile
              ? Container()
              : const Icon(
                  FontAwesomeIcons.google,
                  size: 30,
                  color: kWhite,
                ),
          label: FittedBox(
            child: Text(
              'Continue with Google',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
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
        return CustomIconButton(
          height: kButtonHeight,
          backgroundColor: kBlack,
          leading: screenInfo.screenSize.width <= kScreenSizeMobile
              ? Container()
              : const Icon(
                  FontAwesomeIcons.apple,
                  size: 32,
                  color: kWhite,
                ),
          label: FittedBox(
            child: Text(
              'Continue with Apple',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
            ),
          ),
          onPressed: continueWithApple,
        );
      },
    );
  }

  Widget _buildEmailButton({required BuildContext context}) {
    return CustomElevatedButton(
      height: kButtonHeight,
      side: const BorderSide(width: kBoderWidth, color: kBlack),
      child: FittedBox(
        child: Text(
          'Continue with Email',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.bold,
                color: kBlack,
              ),
        ),
      ),
      onPressed: continueWithEmail,
    );
  }

  Widget _buildSignInButton() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: CustomElevatedButton(
        height: null,
        splashColor: Colors.transparent,
        onPressed: signIn,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Already have an account? ',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'Sign in',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: kBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    if (firebaseAuth.currentUser?.isAnonymous == true) {
      return Container();
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: CustomElevatedButton(
        height: null,
        splashColor: Colors.transparent,
        onPressed: signInAnonymously,
        child: Text(
          'Skip for now',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(color: kGrey),
        ),
      ),
    );
  }
}
