import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/screens/auth_screens/add_info_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/date_picker_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/gender_view.dart';

import 'package:cop_belgium_app/screens/church_selection_screen/church_selection_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/firebase_error_codes.dart';
import 'package:cop_belgium_app/utilities/page_navigation.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SignUpPageView extends StatefulWidget {
  static String signUpScreen = 'signUpScreen';
  const SignUpPageView({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpPageView> createState() => _SignUpPageViewState();
}

class _SignUpPageViewState extends State<SignUpPageView> {
  late final SignUpProvider signUpProvider;
  PageController pageController = PageController();

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    precacheChurchImages(context: context);
    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.close();
    super.dispose();
  }

  Future<void> signUp() async {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    try {
      EasyLoading.show();
      final result = await signUpProvider.signUp();
      if (result == true) {
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: FirebaseErrorCodes().firebaseMessages(e: e),
      );

      await EasyLoading.dismiss();
      if (e.code.contains('email-already-in-use') ||
          e.code.contains('invalid-email')) {
        await pageController.animateToPage(
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
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            AddInfoView(pageController: pageController),
            DatePickerView(pageController: pageController),
            GenderView(pageController: pageController),
            _churchSelectionView(),
          ],
        ),
      ),
    );
  }

  Widget _churchSelectionView() {
    return ChurchSelectionScreen(
      title: 'Select your church',
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: () {
            previousPage(pageContoller: pageController);
          },
        ),
      ),
      onWillPop: () async {
        previousPage(pageContoller: pageController);
        return false;
      },
      onTap: (selectedChurch) {
        FirebaseAuth.instance.signOut();

        if (selectedChurch != null) {
          signUpProvider.setSelectedChurch(value: selectedChurch);
          signUp();
        }
      },
    );
  }
}
