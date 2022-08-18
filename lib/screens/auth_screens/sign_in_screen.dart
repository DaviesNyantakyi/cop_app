import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
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
  late SignUpProvider signUpProvider;

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.close();
    super.dispose();
  }

  Future<void> onSubmit() async {
    try {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      if (emailFormIsValid == true &&
          passwordFormIsValid == true &&
          signUpProvider.emailCntlr.text.isNotEmpty &&
          signUpProvider.passwordCntlr.text.isNotEmpty) {
        EasyLoading.show();

        final user = await FireAuth().signInEmailPassword(
          email: signUpProvider.emailCntlr.text.trim(),
          password: signUpProvider.passwordCntlr.text,
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
        builder: (context) => ChangeNotifierProvider<SignUpProvider>.value(
          value: signUpProvider,
          child: const ForgotPasswordScreen(),
        ),
      ),
    );
  }

  // Validate if all the form fields are filled in
  void validForm() {
    if (emailFormIsValid == true && passwordFormIsValid == true) {
      signUpProvider.validateForm(value: true);
    } else {
      signUpProvider.validateForm(value: false);
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
          suffixIcon: Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: IconButton(
              tooltip: obscureText ? 'Show password' : 'Hide password',
              icon: Icon(
                obscureText ? BootstrapIcons.eye_slash : BootstrapIcons.eye,
                color: kBlack,
              ),
              onPressed: () {
                obscureText = !obscureText;
                setState(() {});
              },
            ),
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

  Widget _buildSignInButton() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return CustomElevatedButton(
          height: kButtonHeight,
          backgroundColor:
              emailFormIsValid == true && passwordFormIsValid == true
                  ? kBlue
                  : kGrey,
          width: double.infinity,
          child: Text(
            'Sign in',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kWhite,
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
      child: GestureDetector(
        child: Text(
          'Forgot password?',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: forgotPassword,
      ),
    );
  }
}
