import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
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
import 'package:provider/provider.dart';

import '../../utilities/load_markdown.dart';

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
  late final SignUpProvider signUpProvider;
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
        if (signUpProvider.formIsValid == true) {
          signUpProvider.setDisplayName();
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
      emailFormIsValid = signUpProvider.emailKey.currentState?.validate();
      passwordFormIsValid = signUpProvider.passwordKey.currentState?.validate();
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

  Widget _buildEmailField() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return Form(
          key: signUpProvider.emailKey,
          child: CustomTextFormField(
            controller: signUpProvider.emailCntlr,
            hintText: 'Email',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailValidator,
            onChanged: (value) {
              emailFormIsValid =
                  signUpProvider.emailKey.currentState?.validate();
              validForm();
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Consumer<SignUpProvider>(builder: (context, signUpProvider, _) {
      return Form(
        key: signUpProvider.passwordKey,
        child: CustomTextFormField(
          controller: signUpProvider.passwordCntlr,
          hintText: 'Password',
          textInputAction: TextInputAction.done,
          validator: Validators.passwordValidator,
          obscureText: obscureText,
          maxLines: 1,
          suffixIcon: GestureDetector(
            child: Icon(
              obscureText ? BootstrapIcons.eye_slash : BootstrapIcons.eye,
              color: kBlack,
            ),
            onTap: () {
              obscureText = !obscureText;
              setState(() {});
            },
          ),
          onChanged: (value) {
            passwordFormIsValid =
                signUpProvider.passwordKey.currentState?.validate();
            validForm();
            setState(() {});
          },
          onSubmitted: (value) => onSubmit(),
        ),
      );
    });
  }

  Widget _buildContinueButton() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return CustomElevatedButton(
          height: kButtonHeight,
          backgroundColor: signUpProvider.formIsValid ? kBlue : kGreyLight,
          width: double.infinity,
          child: Text(
            'Continue',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: signUpProvider.formIsValid ? kWhite : kGrey,
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
        Text(
          'By continuing, you agree to the ',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Text(
                'Privacy Policy',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.w500, color: kBlue),
              ),
              onTap: () {
                loadMarkdownFile(
                  context: context,
                  mdFile: 'assets/privacy/privacy_policy.md',
                );
              },
            ),
            Text(
              ' and ',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Flexible(
              child: InkWell(
                child: Text(
                  'Terms of Conditions.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.w500, color: kBlue),
                ),
                onTap: () {
                  loadMarkdownFile(
                    context: context,
                    mdFile: 'assets/privacy/terms_of_service.md',
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
