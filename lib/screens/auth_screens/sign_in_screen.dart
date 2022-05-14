import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/forgot_password_screen.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
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

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late SignUpNotifier signUpNotifier;

  Future<void> onSubmit() async {
    try {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      // Check for network connection
      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (hasConnection) {
        final signUpNotifier = Provider.of<SignUpNotifier>(
          context,
          listen: false,
        );

        if (signUpNotifier.validForm) {
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
    signUpNotifier.forgotEmailCntlr.clear();
    signUpNotifier.forgotEmailKey.currentState?.reset();
    signUpNotifier.validateForgotEmailForm();

    signUpNotifier.emailCntlr = TextEditingController();
    signUpNotifier.passwordCntlr = TextEditingController();

    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ChangeNotifierProvider<SignUpNotifier>.value(
          value: signUpNotifier,
          child: const ForgotPasswordScreen(),
        ),
      ),
    );
    signUpNotifier.setFormType(formType: FormType.signIn);
    signUpNotifier.validateEmailForm();
    signUpNotifier.validatePasswordForm();
    signUpNotifier.emailKey.currentState?.reset();
    signUpNotifier.passwordKey.currentState?.reset();
  }

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      signUpNotifier.setFormType(formType: FormType.signIn);
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
                _buildEmailField(),
                const SizedBox(height: kContentSpacing8),
                _buildPasswordField(),
                const SizedBox(height: kContentSpacing32),
                _buildSignInButton(),
                const SizedBox(height: kContentSpacing32),
                _buildForgotPasswordButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Sign in with email and password', style: kFontH5),
      ],
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
            signUpNotifier.validatePasswordForm();
          },
          onSubmitted: signUpNotifier.validForm ? (value) => onSubmit : null,
        ),
      );
    });
  }

  Widget _buildSignInButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          backgroundColor: signUpNotifier.validForm ? kBlue : kGreyLight,
          width: double.infinity,
          child: Text(
            'Sign in',
            style: kFontBody.copyWith(
              fontWeight: FontWeight.bold,
              color: signUpNotifier.validForm ? kWhite : kGrey,
            ),
          ),
          onPressed: signUpNotifier.validForm ? onSubmit : null,
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Center(
      child: CustomElevatedButton(
        child: const Text(
          'Forgot password?',
          style: kFontBody,
        ),
        onPressed: forgotPassword,
      ),
    );
  }
}
