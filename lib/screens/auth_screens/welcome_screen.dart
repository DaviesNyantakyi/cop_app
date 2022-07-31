import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
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
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SignUpProvider signUpProvider;
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
            ChangeNotifierProvider<SignUpProvider>.value(
              value: signUpProvider,
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
            ChangeNotifierProvider<SignUpProvider>.value(
              value: signUpProvider,
            ),
          ],
          child: const SignInScreen(),
        ),
      ),
    );
  }

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    super.initState();
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
                  horizontal: screenInfo.screenSize.width >= kScreenTablet
                      ? kContentSpacing64
                      : kContentSpacing16,
                  vertical: kContentSpacing16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    screenInfo.screenSize.height <= kScreenMoible ||
                            screenInfo.screenSize.height < kScreenTablet
                        ? Container()
                        : const SizedBox(height: kContentSpacing32),
                    _buildImage(),
                    screenInfo.screenSize.height <= kScreenMoible ||
                            screenInfo.screenSize.height < kScreenTablet
                        ? Container()
                        : const SizedBox(height: kContentSpacing32),
                    _buildGoogleButton(),
                    const SizedBox(height: kContentSpacing8),
                    _buildAppleButton(),
                    const SizedBox(height: kContentSpacing8),
                    _buildEmailButton(context: context),
                    const SizedBox(height: kContentSpacing32),
                    _buildSignInButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    return ResponsiveBuilder(builder: (context, screenInfo) {
      if (screenInfo.screenSize.height <= kScreenMoible ||
          screenInfo.screenSize.height <= kScreenTablet) {
        return Container();
      }

      if (screenInfo.screenSize.width <= kScreenSmall) {
        return Column(
          children: [
            Text(
              'Church of Pentecost',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: kBlue,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              'Belgium',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: kBlue,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        );
      }
      return Column(
        children: [
          const CopLogo(
            width: 100,
            height: 100,
          ),
          const SizedBox(height: kContentSpacing20),
          Text(
            'Welcome to ',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: kBlue,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            'The Church of Pentecost Belgium',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: kBlue,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      );
    });
  }

  Widget _buildGoogleButton() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return CustomIconButton(
          height: kButtonHeight,
          leading: screenInfo.screenSize.width <= kScreenSmall
              ? Container()
              : const Icon(
                  BootstrapIcons.google,
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
          leading: screenInfo.screenSize.width <= kScreenSmall
              ? Container()
              : const Icon(
                  BootstrapIcons.apple,
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
      side: const BorderSide(),
      backgroundColor: kWhite,
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
}
