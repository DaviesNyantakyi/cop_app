import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/forgot_password_screen.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool? emailFormIsValid;
  bool? passwordFormIsValid;
  bool obscureText = true;

  final user = FirebaseAuth.instance.currentUser;
  late SignUpNotifier signUpNotifier;

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    signUpNotifier.close();
    super.dispose();
  }

  Future<void> onSubmit() async {
    try {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      if (emailFormIsValid == true &&
          passwordFormIsValid == true &&
          signUpNotifier.emailCntlr.text.isNotEmpty &&
          signUpNotifier.passwordCntlr.text.isNotEmpty) {
        EasyLoading.show();

        final user = await FireAuth().signInEmailPassword(
          email: signUpNotifier.emailCntlr.text.trim(),
          password: signUpNotifier.passwordCntlr.text,
        );
        if (user != null) {
          // Leave the SignInScreen
          Navigator.pop(context);
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
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> forgotPassword() async {
    //Unfocus any the textfield before going to the next screen
    FocusScope.of(context).unfocus();
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ChangeNotifierProvider<SignUpNotifier>.value(
          value: signUpNotifier,
          child: const ForgotPasswordScreen(),
        ),
      ),
    );
  }

  // Validate if all the form fields are filled in
  void validForm() {
    if (emailFormIsValid == true && passwordFormIsValid == true) {
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
      child: ResponsiveBuilder(
        builder: (context, screenInfo) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenInfo.screenSize.width >= kScreenTablet
                      ? kContentSpacing24
                      : kContentSpacing16,
                  vertical: kContentSpacing24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeaderText(),
                    const SizedBox(height: kContentSpacing24),
                    _buildEmailField(),
                    const SizedBox(height: kContentSpacing8),
                    _buildPasswordField(),
                    const SizedBox(height: kContentSpacing32),
                    _buildSignInButton(),
                    const SizedBox(height: kContentSpacing24),
                    _buildForgotPasswordButton()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
    );
  }

  Widget _buildHeaderText() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        String text = 'Sign in with email and password';
        if (screenInfo.screenSize.width < kScreenMoible) {
          text = 'Sign in';
        }
        return Text(text, style: Theme.of(context).textTheme.headline5);
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

  Widget _buildSignInButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          height: kButtonHeight,
          backgroundColor:
              emailFormIsValid == true && passwordFormIsValid == true
                  ? kBlue
                  : kGreyLight,
          width: double.infinity,
          child: Text(
            'Sign in',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: emailFormIsValid == true && passwordFormIsValid == true
                      ? kWhite
                      : kGrey,
                ),
          ),
          onPressed: emailFormIsValid == true && passwordFormIsValid == true
              ? onSubmit
              : null,
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Center(
      child: CustomElevatedButton(
        height: null,
        child: Text(
          'Forgot password?',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onPressed: forgotPassword,
      ),
    );
  }
}
