import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late SignUpNotifier signUpNotifier;
  bool? validEmailForm;

  Future<void> onSubmit() async {
    try {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      // Check for network connection
      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (hasConnection) {
        if (validEmailForm == true) {
          // final result = await signUpNotifier.sendPasswordResetEmail();
          // if (result) {
          //   kShowSnackbar(
          //     context: context,
          //     type: SnackBarType.success,
          //     message:
          //         'Password recovery instructions has been sent to ${signUpNotifier.forgotEmailCntlr.text.trim()}',
          //   );
          // }
        }
      } else {
        throw ConnectionNotifier.connectionException;
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
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // signUpNotifier.setFormType(formType: FormType.forgotEmailForm);
    });
    super.initState();
  }

  @override
  void dispose() {
    // signUpNotifier.resetForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildEmailField(),
              const SizedBox(height: kContentSpacing32),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Forgot Password?', style: kFontH5),
        SizedBox(height: kContentSpacing8),
        Text(
          'Enter your email below to receive instructions on how to reset your password',
          style: kFontBody,
        ),
      ],
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
            },
          ),
        );
      },
    );
  }

  Widget _buildSendButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          backgroundColor: kBlue,
          width: double.infinity,
          child: Text(
            'Send',
            style: kFontBody.copyWith(
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
          ),
          onPressed: onSubmit,
        );
      },
    );
  }
}
