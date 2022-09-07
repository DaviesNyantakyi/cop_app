import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../services/fire_auth.dart';
import '../../utilities/validators.dart';
import '../../widgets/buttons.dart';
import '../../widgets/dialog.dart';
import '../../widgets/text_form_field.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({Key? key}) : super(key: key);

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  TextEditingController emailCntlr = TextEditingController();
  TextEditingController passwordCntlr = TextEditingController();
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  bool validForm = false;
  bool? validEmail = false;
  bool? validPassword = false;

  final fireAuth = FireAuth();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailCntlr.dispose();
    emailKey.currentState?.dispose();
    super.dispose();
  }

  void validateForm() {
    if (validEmail == true && validPassword == true) {
      validForm = true;
    } else {
      validForm = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void>? showEmailDialog() {
    FocusScope.of(context).unfocus();

    if (emailCntlr.text.trim() == firebaseAuth.currentUser?.email) {
      Navigator.pop(context);
      return null;
    }
    final validNewEmail = emailKey.currentState?.validate();
    final validPassword = passwordKey.currentState?.validate();

    if (validNewEmail == true && validPassword == true) {
      showCustomDialog(
        context: context,
        title: const Text('PLEASE BE AWARE!'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You will now be logged out of your account and asked to log in again with your new e-mail address:',
            ),
            Text(
              emailCntlr.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: update,
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      );
    }
    return null;
  }

  Future<void> update() async {
    try {
      if (emailCntlr.text.trim() == firebaseAuth.currentUser?.email?.trim()) {
        Navigator.pop(context);
        return;
      }

      bool success = false;

      final validNewEmail = emailKey.currentState?.validate();
      final validPassword = passwordKey.currentState?.validate();

      if (validNewEmail == true &&
          validPassword == true &&
          emailCntlr.text.isNotEmpty) {
        EasyLoading.show();

        success = await fireAuth.updateEmail(
          email: emailCntlr.text,
          password: passwordCntlr.text,
        );

        if (success) {
          if (mounted) {
            Navigator.of(context)
              ..pop()
              ..pop()
              ..pop();
          }
        }
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        message: e.message!,
        type: CustomSnackBarType.error,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kContentSpacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderText(),
              const SizedBox(height: kContentSpacing12),
              _buildEmailField(),
              const SizedBox(height: kContentSpacing8),
              _buildPasswordField(),
              const SizedBox(height: kContentSpacing32),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text('Email',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHeaderText() {
    final textStyle = Theme.of(context).textTheme.bodyText1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Changing your email address is a permanent',
          style: textStyle,
        ),
        Text(
          'and you\'ll have to sign in with the new email address going forward. ',
          style: textStyle,
        )
      ],
    );
  }

  Widget _buildEmailField() {
    return Form(
      key: emailKey,
      child: CustomTextFormField(
        hintText: 'New email',
        controller: emailCntlr,
        maxLines: 1,
        validator: Validators.emailValidator,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          validEmail = emailKey.currentState?.validate();
          if (mounted) {
            setState(() {});
          }
          validateForm();
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Form(
      key: passwordKey,
      child: CustomTextFormField(
        hintText: 'Confirm with your password',
        controller: passwordCntlr,
        maxLines: 1,
        obscureText: true,
        validator: Validators.passwordValidator,
        textInputAction: TextInputAction.done,
        onChanged: (value) {
          validPassword = passwordKey.currentState?.validate();
          if (mounted) {
            setState(() {});
          }
          validateForm();
        },
      ),
    );
  }

  Widget _buildUpdateButton() {
    return CustomElevatedButton(
      height: kButtonHeight,
      backgroundColor: validForm ? kBlue : kGrey,
      width: double.infinity,
      child: Text(
        'Update',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.bold, color: kWhite),
      ),
      onPressed: validForm ? showEmailDialog : null,
    );
  }
}
