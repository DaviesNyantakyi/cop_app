import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCntlr = TextEditingController();
  final emailKey = GlobalKey<FormState>();
  FireAuth fireAuth = FireAuth();

  bool? formIsValid;

  Future<void> onSubmit() async {
    final email = emailCntlr.text;

    try {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      if (formIsValid == true && emailCntlr.text.isNotEmpty) {
        EasyLoading.show();
        final result = await fireAuth.sendPasswordResetEmail(email: email);
        if (result) {
          showCustomSnackBar(
            context: context,
            type: CustomSnackBarType.success,
            message: 'Password recovery instructions has been sent to $email',
          );
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

  @override
  void dispose() {
    emailCntlr.clear();
    emailKey.currentState?.reset();
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
      children: [
        Text('Forgot Password?', style: Theme.of(context).textTheme.headline5),
        const SizedBox(height: kContentSpacing8),
        Text(
          'Enter your email below to receive instructions on how to reset your password',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Form(
      key: emailKey,
      child: CustomTextFormField(
        controller: emailCntlr,
        hintText: 'Email',
        textInputAction: TextInputAction.next,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        validator: Validators.emailValidator,
        onChanged: (value) {
          formIsValid = emailKey.currentState?.validate();
          setState(() {});
        },
      ),
    );
  }

  Widget _buildSendButton() {
    return CustomElevatedButton(
      backgroundColor: formIsValid == true ? kBlue : kGreyLight,
      height: kButtonHeight,
      width: double.infinity,
      child: Text(
        'Send',
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.bold,
              color: formIsValid == true ? kWhite : kGrey,
            ),
      ),
      onPressed: formIsValid == true ? onSubmit : null,
    );
  }
}
