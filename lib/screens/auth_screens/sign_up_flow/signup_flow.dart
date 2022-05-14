import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/date_picker_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/gender_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/add_info_view.dart';
import 'package:cop_belgium_app/screens/church_selection_screen/church_selection_screen.dart';
import 'package:cop_belgium_app/screens/profile_picker_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/methods.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SignUpFlow extends StatefulWidget {
  static String signUpScreen = 'signUpScreen';
  const SignUpFlow({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends State<SignUpFlow> {
  late final SignUpNotifier signUpProvider;
  PageController pageController = PageController();

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpNotifier>(context, listen: false);
    Provider.of<SignUpNotifier>(context, listen: false).resetForm();
    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.resetForm();
    super.dispose();
  }

  Future<void> signUp({required ChurchModel church}) async {
    final signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    try {
      EasyLoading.show();
      signUpNotifier.setSelectedChurch(value: church);
      final user = await signUpNotifier.signUp();

      if (user != null) {
        nextPage(controller: pageController);
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
