import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_screens/date_picker_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_screens/gender_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_screens/info_view.dart';
import 'package:cop_belgium_app/screens/profile_picker_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/screens/church_selection_view/church_selection_view.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SignUpPageScreen extends StatefulWidget {
  static String signUpScreen = 'signUpScreen';
  const SignUpPageScreen({Key? key}) : super(key: key);

  @override
  State<SignUpPageScreen> createState() => _SignUpPageScreenState();
}

class _SignUpPageScreenState extends State<SignUpPageScreen> {
  PageController pageController = PageController(initialPage: 0);

  late final SignUpNotifier signUpProvider;

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpNotifier>(context, listen: false);
    Provider.of<SignUpNotifier>(context, listen: false).close();
    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.close();
    super.dispose();
  }

  Future<void> backButton() async {
    await pageController.previousPage(
      duration: kPagViewDuration,
      curve: kPagViewCurve,
    );
  }

  Future<void> submit() async {
    Navigator.pop(context);
  }

  Future<bool> onWillPop() async {
    await backButton();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<PageController>.value(
              value: pageController,
            ),
          ],
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              const AddInfoView(),
              const DatePickerView(),
              const GenderView(),
              const _ChurchSelectionView(),
              ProfilePickerScreen(
                onWillpop: () async {
                  onWillPop();
                  return false;
                },
                submitButton: submit,
                backButton: backButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChurchSelectionView extends StatefulWidget {
  const _ChurchSelectionView({Key? key}) : super(key: key);

  @override
  State<_ChurchSelectionView> createState() => _ChurchSelectionViewState();
}

class _ChurchSelectionViewState extends State<_ChurchSelectionView> {
  Future<void> _nextPage() async {
    await Provider.of<PageController>(context, listen: false).nextPage(
      duration: kPagViewDuration,
      curve: kPagViewCurve,
    );
  }

  Future<void> _previousPage() async {
    await Provider.of<PageController>(context, listen: false).previousPage(
      duration: kPagViewDuration,
      curve: kPagViewCurve,
    );
  }

  Future<void> signUp({required ChurchModel church}) async {
    final signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    try {
      EasyLoading.show();
      signUpNotifier.setSelectedChurch(value: church);
      final user = await signUpNotifier.signUp();
      if (user != null) {
        _nextPage();
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
        await Provider.of<PageController>(context, listen: false).animateToPage(
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
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return WillPopScope(
          onWillPop: () async {
            await _previousPage();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: CustomBackButton(onPressed: _previousPage),
              title: const Text('Church', style: kFontH6),
            ),
            body: ChurchSelectionView(
              onTap: (church) {
                if (church != null) {
                  signUp(church: church);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
