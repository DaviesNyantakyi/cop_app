import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/screens/auth_screens/date_picker_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/gender_view.dart';

import 'package:cop_belgium_app/screens/church_selection_screen/church_selection_screen.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/page_navigation.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../utilities/load_markdown.dart';

class MissingInfoPageView extends StatefulWidget {
  static String signUpScreen = 'signUpScreen';
  const MissingInfoPageView({
    Key? key,
  }) : super(key: key);

  @override
  State<MissingInfoPageView> createState() => _MissingInfoPageViewState();
}

class _MissingInfoPageViewState extends State<MissingInfoPageView> {
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

  Future<void> updateInfo() async {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    try {
      EasyLoading.show();

      await signUpProvider.updateUpdateInfo();
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
            _AddInfoView(pageController: pageController),
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
      title: "Select your church",
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
      onTap: (setSelectedChurch) {
        if (setSelectedChurch != null) {
          signUpProvider.setSelectedChurch(value: setSelectedChurch);
          updateInfo();
        }
      },
    );
  }
}

class _AddInfoView extends StatefulWidget {
  final PageController pageController;
  const _AddInfoView({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<_AddInfoView> createState() => _AddInfoViewState();
}

class _AddInfoViewState extends State<_AddInfoView> {
  final user = FirebaseAuth.instance.currentUser;
  late final SignUpProvider signUpProvider;

  bool? firstNameFormIsValid;
  bool? lastNameFormIsValid;

  @override
  void initState() {
    // addPostFrameCallback is called after the screen and the widget has been renderd.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      revalidateForm();
    });

    super.initState();
  }

  Future<void> onSubmit() async {
    // Hide keyboard

    FocusScope.of(context).unfocus();
    try {
      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (hasConnection) {
        if (signUpProvider.formIsValid == true &&
            user != null &&
            user?.email != null) {
          signUpProvider.setDisplayName();
          signUpProvider.setEmail(email: user!.email!);

          await nextPage(controller: widget.pageController);
        }
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Validate if all the form fields are filled in
  void validForm() {
    if (firstNameFormIsValid == true && lastNameFormIsValid == true) {
      signUpProvider.validateForm(value: true);
    } else {
      signUpProvider.validateForm(value: false);
    }
  }

  void revalidateForm() {
    // The form state remains valid when coming back from the orther screen.
    // So we validated again.

    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    if (signUpProvider.formIsValid == true) {
      firstNameFormIsValid =
          signUpProvider.firstNameKey.currentState?.validate();
      lastNameFormIsValid = signUpProvider.lastNameKey.currentState?.validate();
      validForm();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: kContentSpacing16,
              vertical: kContentSpacing24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeaderText(),
                const SizedBox(height: kContentSpacing24),
                _buildFirstNameField(),
                const SizedBox(height: kContentSpacing8),
                _buildLastNameField(),
                const SizedBox(height: kContentSpacing32),
                _buildContinueButton(),
                const SizedBox(height: kContentSpacing32),
                _buildPolicyText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text('Add your info', style: Theme.of(context).textTheme.headline5);
  }

  Widget _buildFirstNameField() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return Form(
          key: signUpProvider.firstNameKey,
          child: CustomTextFormField(
            controller: signUpProvider.firstNameCntlr,
            hintText: 'First name',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            validator: Validators.nameValidator,
            onChanged: (value) {
              firstNameFormIsValid =
                  signUpProvider.firstNameKey.currentState?.validate();
              setState(() {});
              validForm();
            },
          ),
        );
      },
    );
  }

  Widget _buildLastNameField() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return Form(
          key: signUpProvider.lastNameKey,
          child: CustomTextFormField(
            controller: signUpProvider.lastNameCntlr,
            hintText: 'Last name',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            validator: Validators.nameValidator,
            onChanged: (value) {
              lastNameFormIsValid =
                  signUpProvider.lastNameKey.currentState?.validate();
              validForm();
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return CustomElevatedButton(
          height: kButtonHeight,
          backgroundColor: signUpProvider.formIsValid ? kBlue : kGrey,
          width: double.infinity,
          child: Text(
            'Continue',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kWhite,
                ),
          ),
          onPressed: signUpProvider.formIsValid ? onSubmit : null,
        );
      },
    );
  }

  Widget _buildPolicyText() {
    return Column(
      children: [
        const Text(
          'By continuing, you agree to the ',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Text(
                'Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.w500, color: kBlue),
              ),
              onTap: () {
                loadMarkdownFile(
                  context: context,
                  mdFile: 'assets/privacy/privacy_policy.md',
                );
              },
            ),
            const Text(
              ' and',
            ),
            GestureDetector(
              child: const Text(
                ' Terms of Conditions.',
                style: TextStyle(fontWeight: FontWeight.w500, color: kBlue),
              ),
              onTap: () {
                loadMarkdownFile(
                  context: context,
                  mdFile: 'assets/privacy/terms_of_service.md',
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
