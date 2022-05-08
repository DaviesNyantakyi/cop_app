import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/date_picker_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/gender_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/info_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/signup_flow.dart';

import 'package:cop_belgium_app/screens/church_selection_screen/church_selection_screen.dart';
import 'package:cop_belgium_app/screens/profile_picker_screen.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
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
  Future<void> continueWithApple() async {}

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

  Future<void> continueWithEmail() async {
    final signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<SignUpNotifier>.value(
              value: signUpNotifier,
            ),
          ],
          child: const _SignUpFlow(),
        ),
      ),
    );
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
      onPressed: continueWithGoogle,
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
      onPressed: continueWithApple,
    );
  }

  Future<void> submit() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Check for network connection
    bool hasConnection = await ConnectionNotifier().checkConnection();

    if (hasConnection) {
      final signUpNotifier = Provider.of<SignUpNotifier>(
        context,
        listen: false,
      );

      final pageController = Provider.of<PageController>(
        context,
        listen: false,
      );

      // Validate the text field before continuing.
      final validFirstName = signUpNotifier.validateFirstNameForm();
      final validLastName = signUpNotifier.validateLastNameForm();
      final validEmail = signUpNotifier.validateEmailForm();
      final validPassword = signUpNotifier.validatePassword();

      if (validFirstName == true &&
          validLastName == true &&
          validEmail == true &&
          validPassword == true) {
        signUpNotifier.setDisplayName();
        await pageController.nextPage(
          duration: kPagViewDuration,
          curve: kPagViewCurve,
        );
      }
    } else {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: ConnectionNotifier.connectionException.message ?? '',
      );
    }
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
          onPressed: continueWithEmail,
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

class _SignUpFlow extends StatefulWidget {
  const _SignUpFlow({Key? key}) : super(key: key);

  @override
  State<_SignUpFlow> createState() => __SignUpFlowState();
}

class __SignUpFlowState extends State<_SignUpFlow> {
  late SignUpNotifier signUpNotifier;
  PageController controller = PageController();

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    signUpNotifier.close();
    super.dispose();
  }

  Future<void> nextPage() async {
    controller.nextPage(
      duration: kPagViewDuration,
      curve: kPagViewCurve,
    );
  }

  Future<void> previousPage() async {
    controller.previousPage(
      duration: kPagViewDuration,
      curve: kPagViewCurve,
    );
  }

  Future<bool> onWillPop() async {
    previousPage();
    return false;
  }

  void addInfoOnSubmit() {
    //Set the displayName before going to the nextScreen
    final signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);

    signUpNotifier.setDisplayName();
    nextPage();
  }

  Future<void> signUp({required ChurchModel church}) async {
    final signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    try {
      EasyLoading.show();
      signUpNotifier.setSelectedChurch(value: church);
      final user = await signUpNotifier.signUp();

      if (user != null) {
        nextPage();
      }
    } on FirebaseException catch (e) {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: e.message ?? '',
      );
      await EasyLoading.dismiss();

      if (e.code.contains('email-already-in-use') ||
          e.code.contains('invalid-email')) {
        await controller.animateToPage(
          0,
          duration: kPagViewDuration,
          curve: kPagViewCurve,
        );
      }
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignUpPageFlow(
      controller: controller,
      children: [
        _addInfoView(),
        _datePickerView(),
        _genderView(),
        _churchSelectionView(),
        _profilePickerView()
      ],
    );
  }

  Widget _addInfoView() {
    return AddInfoView(
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      onWillPop: () async {
        // if set to true, you are able to leave the  current screen.
        return true;
      },
      onSubmit: addInfoOnSubmit,
    );
  }

  Widget _datePickerView() {
    return DatePickerView(
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: previousPage,
        ),
      ),
      onWillPop: onWillPop,
      onSubmit: nextPage,
    );
  }

  Widget _genderView() {
    return GenderView(
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: previousPage,
        ),
      ),
      onWillPop: onWillPop,
      onSubmit: nextPage,
    );
  }

  Widget _churchSelectionView() {
    return ChurchSelectionScreen(
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: previousPage,
        ),
      ),
      onWillPop: onWillPop,
      onTap: (church) {
        if (church != null) {
          signUp(church: church);
        }
      },
    );
  }

  Widget _profilePickerView() {
    return ProfilePickerScreen(
      appBar: AppBar(
        leading: CustomBackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      onSubmit: () async {
        Navigator.pop(context);
      },
    );
  }
}
