import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddInfoView extends StatefulWidget {
  const AddInfoView({Key? key}) : super(key: key);

  @override
  State<AddInfoView> createState() => _AddInfoViewState();
}

class _AddInfoViewState extends State<AddInfoView> {
  Future<void> submit() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Check for network connection
    bool hasConnection = await ConnectionChecker().checkConnection();

    if (hasConnection) {
      final signUpNotifier = Provider.of<SignUpNotifier>(
        context,
        listen: false,
      );
      // Validate the text field before continuing.
      final validFirstName = signUpNotifier.validateFirstNameForm();
      final validLastName = signUpNotifier.validateLastNameForm();
      final validEmail = signUpNotifier.validateEmailForm();
      final validPassword = signUpNotifier.validatePassword();
      setState(() {});

      if (validFirstName == true &&
          validLastName == true &&
          validEmail == true &&
          validPassword == true) {
        await Provider.of<PageController>(context, listen: false).nextPage(
          duration: kPagViewDuration,
          curve: kPagViewCurve,
        );
      }
    } else {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: ConnectionChecker.connectionException.message ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _backButton(),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: kContentSpacing16,
              vertical: kContentSpacing24,
            ),
            child: IntrinsicHeight(
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
          );
        }),
      ),
    );
  }

  Widget _backButton() {
    return CustomElevatedButton(
      child: const Icon(
        Icons.chevron_left,
        color: kBlack,
        size: 40,
      ),
      onPressed: () => Navigator.pop(context),
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
          child: CustomTextField(
            controller: signUpNotifier.firstNameCntlr,
            hintText: 'First name',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            validator: Validators.nameValidator,
            onChanged: (value) {
              signUpNotifier.validateFirstNameForm();
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
          child: CustomTextField(
            controller: signUpNotifier.lastNameCntlr,
            hintText: 'Last name',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            validator: Validators.nameValidator,
            onChanged: (value) {
              signUpNotifier.validateLastNameForm();
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
          child: CustomTextField(
            controller: signUpNotifier.emailCntlr,
            hintText: 'Email',
            textInputAction: TextInputAction.next,
            maxLines: 1,
            validator: Validators.emailValidator,
            onChanged: (value) {
              signUpNotifier.validateEmailForm();
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
        child: CustomTextField(
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
            signUpNotifier.validatePassword();
          },
          onSubmitted: signUpNotifier.validForm ? (value) => submit() : null,
        ),
      );
    });
  }

  Widget _buildContinueButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          backgroundColor: signUpNotifier.validForm ? kBlue : kGreyLight,
          width: double.infinity,
          child: Text(
            'Continue',
            style: kFontBody.copyWith(
              fontWeight: FontWeight.bold,
              color: signUpNotifier.validForm ? kWhite : kGrey,
            ),
          ),
          onPressed: signUpNotifier.validForm ? submit : null,
        );
      },
    );
  }

  Widget _buildPolicyText() {
    return Column(
      children: [
        const Text(
          'By creating an account, you agree to the ',
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
