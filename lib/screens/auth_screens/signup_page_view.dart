import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/add_info_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/date_picker_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/gender_view.dart';

import 'package:cop_belgium_app/screens/church_selection_screen/church_selection_screen.dart';
import 'package:cop_belgium_app/screens/profile_picker_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
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
  late final SignUpNotifier signUpProvider;
  PageController pageController = PageController();

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpNotifier>(context, listen: false);
    precacheChurchImages(context: context);
    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.close();
    super.dispose();
  }

  Future<void> signUp({required ChurchModel selectedChurch}) async {
    final signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    try {
      EasyLoading.show();
      signUpNotifier.setSelectedChurch(value: selectedChurch);
      final user = await signUpNotifier.signUp();

      if (user != null) {
        nextPage(controller: pageController);
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
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
            _profilePickerView(),
          ],
        ),
      ),
    );
  }

  Widget _churchSelectionView() {
    return ChurchSelectionScreen(
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
      onTap: (church) {
        if (church != null) {
          signUp(selectedChurch: church);
        }
      },
    );
  }

  Widget _profilePickerView() {
    return ProfilePickerScreen(
      appBar: AppBar(
        leading: const CustomBackButton(),
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
