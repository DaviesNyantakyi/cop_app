import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../services/fire_auth.dart';
import '../../utilities/constant.dart';
import '../../utilities/responsive.dart';
import '../../utilities/validators.dart';
import '../../widgets/back_button.dart';
import '../../widgets/dialog.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({Key? key}) : super(key: key);

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final fireAuth = FireAuth();
  bool obscureText = true;
  bool? validPassword = false;
  bool? validEmail = false;
  bool? validForm = false;

  final providerId =
      FirebaseAuth.instance.currentUser?.providerData[0].providerId;

  TextEditingController passwordCntrl = TextEditingController();
  TextEditingController emailCntlr = TextEditingController();
  final passwordKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();

  void validateForm() {
    if (validEmail == true && validPassword == true) {
      validForm = true;
    } else {
      validForm = false;
    }
    setState(() {});
  }

  Future<void> deleteAccount() async {
    try {
      Navigator.of(context).pop(); // pop dialog
      EasyLoading.show();
      bool success = false;

      if (providerId == fireAuth.providerIdEmail) {
        validEmail = emailKey.currentState?.validate();

        validPassword = passwordKey.currentState?.validate();

        if (validEmail == true &&
            validPassword == true &&
            passwordCntrl.text.isNotEmpty &&
            emailCntlr.text.isNotEmpty) {
          success = await fireAuth.deleteEmailAccount(
            email: emailCntlr.text,
            password: passwordCntrl.text,
          );
        }
      }

      if (providerId == fireAuth.providerIdGoogle) {
        success = await fireAuth.deleteGoogleAccount();
      }

      if (providerId == fireAuth.providerIdApple) {
        success = await fireAuth.deleteAppleAccount();
      }

      if (success) {
        if (mounted) {
          Navigator.of(context)
            ..pop() // pop VerifyAccountScreen
            ..pop() // pop AccountScreen
            ..pop(); // pop SettingsScreen
        }
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        message: e.message ?? '',
        type: CustomSnackBarType.error,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
      passwordCntrl.clear();
      passwordKey.currentState?.reset();
    }
  }

  Future<void> showDeleteDialog() async {
    FocusScope.of(context).unfocus();

    showCustomDialog(
      context: context,
      title: RichText(
        text: TextSpan(
          text: 'Are you sure you want to delete account ',
          style: Theme.of(context).textTheme.bodyText1,
          children: [
            TextSpan(
              text: FirebaseAuth.instance.currentUser?.displayName ?? '',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextSpan(
              text: '?',
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
        textAlign: TextAlign.center,
      ),
      actions: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: SizedBox(
                height: double.infinity,
                child: Center(
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: deleteAccount,
              child: SizedBox(
                height: double.infinity,
                child: Center(
                  child: Text(
                    'Delete',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: kRed),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kContentSpacing16),
          child: Column(
            children: [
              _buildHeading(),
              const SizedBox(height: kContentSpacing32),
              _buildVerificationForm()
            ],
          ),
        ),
      ),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify your account',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: kContentSpacing12),
        RichText(
          text: TextSpan(
            text: 'Sign in so that we can confirm the account ',
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(
                text: FirebaseAuth.instance.currentUser?.displayName ?? '',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextSpan(
                text: ' belongs to you.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildVerificationForm() {
    if (providerId == fireAuth.providerIdEmail) {
      return _buildEmailForm();
    } else if (providerId == fireAuth.providerIdGoogle) {
      return _buildGoogleButton();
    } else if (providerId == fireAuth.providerIdApple) {
      return _buildAppleButton();
    }
    return Container();
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        Form(
          key: emailKey,
          child: CustomTextFormField(
            controller: emailCntlr,
            hintText: 'Email',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailValidator,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.grey.shade600),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: kBoderWidth, color: kGrey),
            ),
            onChanged: (value) {
              validEmail = emailKey.currentState?.validate();
              setState(() {});
              validateForm();
            },
          ),
        ),
        const SizedBox(height: kContentSpacing8),
        Form(
          key: passwordKey,
          child: CustomTextFormField(
            controller: passwordCntrl,
            maxLines: 1,
            hintText: 'Password',
            obscureText: obscureText,
            validator: Validators.passwordValidator,
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
              validPassword = passwordKey.currentState?.validate();
              setState(() {});
              validateForm();
            },
          ),
        ),
        const SizedBox(height: kContentSpacing32),
        CustomElevatedButton(
          height: kButtonHeight,
          backgroundColor: validForm == true ? kRed : kGrey,
          width: double.infinity,
          child: FittedBox(
            child: Text(
              'Delete account',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
            ),
          ),
          onPressed: validForm == true ? showDeleteDialog : null,
        )
      ],
    );
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
          onPressed: showDeleteDialog,
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
          onPressed: showDeleteDialog,
        );
      },
    );
  }
}
