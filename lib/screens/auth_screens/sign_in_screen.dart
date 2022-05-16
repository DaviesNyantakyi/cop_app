import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/forgot_password_screen.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/textfield.dart';
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
  bool? validEmailForm;
  bool? validPasswordForm;

  final user = FirebaseAuth.instance.currentUser;
  late SignUpNotifier signUpNotifier;

  Future<void> onSubmit() async {
    try {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      // Check for network connection
      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (hasConnection) {
        if (validEmailForm == true && validPasswordForm == true) {
          EasyLoading.show();
          final user = await signUpNotifier.signIn();
          if (user != null) {
            // Leave the SignInScreen
            Navigator.pop(context);
          }
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
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

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      signUpNotifier.setFormType(formType: FormType.signInForm);
    });
    super.initState();
  }

  @override
  void dispose() {
    signUpNotifier.resetForm();
    super.dispose();
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
                  horizontal: screenInfo.screenSize.width >= kScreenSizeTablet
                      ? kContentSpacing24
                      : kContentSpacing16,
                  vertical: kContentSpacing24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeaderText(),
                    const SizedBox(height: kContentSpacing32),
                    _buildEmailField(),
                    const SizedBox(height: kContentSpacing8),
                    _buildPasswordField(),
                    const SizedBox(height: kContentSpacing32),
                    _buildSignInButton(),
                    const SizedBox(height: kContentSpacing20),
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
      leading: CustomBackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildHeaderText() {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        String text = 'Sign in with email and password';
        if (screenInfo.screenSize.width < kScreenSizeMobile) {
          text = 'Sign in';
        }
        return Text(text, style: kFontH5);
      },
    );
  }

  Widget _buildEmailField() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return Form(
          key: signUpNotifier.emailKey,
          child: CustomTextField(
            key: ObjectKey(signUpNotifier.emailCntlr),
            controller: signUpNotifier.emailCntlr,
            hintText: 'Email',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            validator: Validators.emailValidator,
            onChanged: (value) {
              validEmailForm = signUpNotifier.emailKey.currentState?.validate();
              if (mounted) {
                setState(() {});
              }
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
          key: ObjectKey(signUpNotifier.passwordCntlr),
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
            validPasswordForm =
                signUpNotifier.passwordKey.currentState?.validate();
            if (mounted) {
              setState(() {});
            }
          },
          onSubmitted: validPasswordForm == true ? (value) => onSubmit() : null,
        ),
      );
    });
  }

  Widget _buildSignInButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          backgroundColor: validEmailForm == true && validPasswordForm == true
              ? kBlue
              : kGreyLight,
          width: double.infinity,
          child: Text(
            'Sign in',
            style: kFontBody.copyWith(
              fontWeight: FontWeight.bold,
              color: validEmailForm == true && validPasswordForm == true
                  ? kWhite
                  : kGrey,
            ),
          ),
          onPressed: validEmailForm == true && validPasswordForm == true
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
        child: const Text(
          'Forgot password?',
          style: kFontBody,
        ),
        onPressed: forgotPassword,
      ),
    );
  }
}
