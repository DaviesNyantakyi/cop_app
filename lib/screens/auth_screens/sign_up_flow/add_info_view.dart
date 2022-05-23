import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/page_navigation.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/textfield.dart';
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

  bool? validFirstNameForm;
  bool? validLastNameForm;
  bool? validEmailForm;
  bool? validPasswordForm;

  @override
  void initState() {
    // addPostFrameCallback is called after the screen and the widget has been renderd.
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);

      // When coming back from the other screen,
      // The button is enabled and the form remains valid even if one field is not valid.
      // So form is validated again even if the form is valid.
      if (signUpNotifier.formIsValid == true) {
        validFirstNameForm =
            signUpNotifier.firstNameKey.currentState?.validate();
        validLastNameForm = signUpNotifier.lastNameKey.currentState?.validate();
        validEmailForm = signUpNotifier.emailKey.currentState?.validate();
        validPasswordForm = signUpNotifier.passwordKey.currentState?.validate();
        validForm();
      }
      if (mounted) {
        setState(() {});
      }
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
        type: SnackBarType.error,
        message: e.message ?? '',
      );
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Validate if all the form fields are filled in
  void validForm() {
    if (validFirstNameForm == true &&
        validLastNameForm == true &&
        validEmailForm == true &&
        validPasswordForm == true) {
      signUpNotifier.validateForm(value: true);
    } else {
      signUpNotifier.validateForm(value: false);
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
                const SizedBox(height: kContentSpacing32),
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
    return const Text('Add your info', style: kFontH5);
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
              validFirstNameForm =
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
              validLastNameForm =
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
              validEmailForm = signUpNotifier.emailKey.currentState?.validate();
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
            validPasswordForm =
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
            style: kFontBody.copyWith(
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
                style: TextStyle(fontWeight: FontWeight.bold, color: kBlue),
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
                ' Terms of Conditions',
                style: TextStyle(fontWeight: FontWeight.bold, color: kBlue),
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
