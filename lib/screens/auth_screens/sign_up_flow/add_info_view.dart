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

  // Validate the text field before continuing.
  bool? validFirstNameForm;
  bool? validLastNameForm;
  bool? validEmailForm;
  bool? validPassword;

  Future<void> onSubmit() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Check for network connection
    bool hasConnection = await ConnectionNotifier().checkConnection();

    if (hasConnection) {
      final signUpNotifier = Provider.of<SignUpNotifier>(
        context,
        listen: false,
      );

      if (validFirstNameForm == true &&
          validLastNameForm == true &&
          validEmailForm == true &&
          validPassword == true) {
        signUpNotifier.setDisplayName();
        await nextPage(controller: widget.pageController);
      }
    } else {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: ConnectionNotifier.connectionException.message ?? '',
      );
    }
  }

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
          obscureText: signUpNotifier.obscureText,
          maxLines: 1,
          suffixIcon: GestureDetector(
            child: Icon(
              signUpNotifier.obscureText
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: kBlack,
            ),
            onTap: signUpNotifier.togglePasswordView,
          ),
          onChanged: (value) {
            validPassword = signUpNotifier.passwordKey.currentState?.validate();
            setState(() {});
          },
          onSubmitted: validFirstNameForm == true &&
                  validLastNameForm == true &&
                  validEmailForm == true &&
                  validPassword == true
              ? (value) => onSubmit()
              : null,
        ),
      );
    });
  }

  Widget _buildContinueButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          backgroundColor: validFirstNameForm == true &&
                  validLastNameForm == true &&
                  validEmailForm == true &&
                  validPassword == true
              ? kBlue
              : kGreyLight,
          width: double.infinity,
          child: Text(
            'Continue',
            style: kFontBody.copyWith(
              fontWeight: FontWeight.bold,
              color: validFirstNameForm == true &&
                      validLastNameForm == true &&
                      validEmailForm == true &&
                      validPassword == true
                  ? kWhite
                  : kGrey,
            ),
          ),
          onPressed: validFirstNameForm == true &&
                  validLastNameForm == true &&
                  validEmailForm == true &&
                  validPassword == true
              ? onSubmit
              : null,
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
