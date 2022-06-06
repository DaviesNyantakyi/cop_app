import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/page_navigation.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddInfoView extends StatefulWidget {
  final PageController pageController;
  const AddInfoView({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<AddInfoView> createState() => _AddInfoViewState();
}

class _AddInfoViewState extends State<AddInfoView> {
  final user = FirebaseAuth.instance.currentUser;
  late final SignUpNotifier signUpNotifier;
  bool obscureText = true;

  bool? firstNameFormIsValid;
  bool? lastNameFormIsValid;
  bool? emailFormIsValid;
  bool? passwordFormIsValid;

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
        if (signUpNotifier.formIsValid == true) {
          signUpNotifier.setDisplayName();
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
    if (firstNameFormIsValid == true &&
        lastNameFormIsValid == true &&
        emailFormIsValid == true &&
        passwordFormIsValid == true) {
      signUpNotifier.validateForm(value: true);
    } else {
      signUpNotifier.validateForm(value: false);
    }
  }

  void revalidateForm() {
    // The form state remains valid when coming back from the orther screen.
    // So we validated again.

    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    if (signUpNotifier.formIsValid == true) {
      firstNameFormIsValid =
          signUpNotifier.firstNameKey.currentState?.validate();
      lastNameFormIsValid = signUpNotifier.lastNameKey.currentState?.validate();
      emailFormIsValid = signUpNotifier.emailKey.currentState?.validate();
      passwordFormIsValid = signUpNotifier.passwordKey.currentState?.validate();
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
          leading: const CustomBackButton(),
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
                const SizedBox(height: kContentSpacing8),
                _buildEmailField(),
                const SizedBox(height: kContentSpacing8),
                _buildPasswordField(),
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
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return Form(
          key: signUpNotifier.firstNameKey,
          child: CustomTextFormField(
            controller: signUpNotifier.firstNameCntlr,
            hintText: 'First name',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            validator: Validators.nameValidator,
            onChanged: (value) {
              firstNameFormIsValid =
                  signUpNotifier.firstNameKey.currentState?.validate();
              setState(() {});
              validForm();
            },
          ),
        );
      },
    );
  }

  Widget _buildLastNameField() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return Form(
          key: signUpNotifier.lastNameKey,
          child: CustomTextFormField(
            controller: signUpNotifier.lastNameCntlr,
            hintText: 'Last name',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            validator: Validators.nameValidator,
            onChanged: (value) {
              lastNameFormIsValid =
                  signUpNotifier.lastNameKey.currentState?.validate();
              validForm();
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Widget _buildEmailField() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return Form(
          key: signUpNotifier.emailKey,
          child: CustomTextFormField(
            controller: signUpNotifier.emailCntlr,
            hintText: 'Email',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailValidator,
            onChanged: (value) {
              emailFormIsValid =
                  signUpNotifier.emailKey.currentState?.validate();
              validForm();
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Consumer<SignUpNotifier>(builder: (context, signUpNotifier, _) {
      return Form(
        key: signUpNotifier.passwordKey,
        child: CustomTextFormField(
          controller: signUpNotifier.passwordCntlr,
          hintText: 'Password',
          textInputAction: TextInputAction.done,
          validator: Validators.passwordValidator,
          obscureText: obscureText,
          maxLines: 1,
          suffixIcon: GestureDetector(
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: kBlack,
            ),
            onTap: () {
              obscureText = !obscureText;
              setState(() {});
            },
          ),
          onChanged: (value) {
            passwordFormIsValid =
                signUpNotifier.passwordKey.currentState?.validate();
            validForm();
            setState(() {});
          },
          onSubmitted: (value) => onSubmit(),
        ),
      );
    });
  }

  Widget _buildContinueButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          height: kButtonHeight,
          backgroundColor: signUpNotifier.formIsValid ? kBlue : kGreyLight,
          width: double.infinity,
          child: Text(
            'Continue',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: signUpNotifier.formIsValid ? kWhite : kGrey,
                ),
          ),
          onPressed: signUpNotifier.formIsValid ? onSubmit : null,
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
            InkWell(
              child: const Text(
                'Privacy Policy',
                style: TextStyle(fontWeight: kFontWeightMedium, color: kBlue),
              ),
              onTap: () {
                loadMdFile(
                  context: context,
                  mdFile: 'assets/privacy/privacy_policy.md',
                );
              },
            ),
            const Text(
              ' and',
            ),
            InkWell(
              child: const Text(
                ' Terms of Conditions.',
                style: TextStyle(fontWeight: kFontWeightMedium, color: kBlue),
              ),
              onTap: () {
                loadMdFile(
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
