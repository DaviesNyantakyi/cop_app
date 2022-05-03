import 'package:cop_belgium_app/screens/auth_screens/gender_view.dart';
import 'package:flutter/material.dart';

class SignUpNotifier extends ChangeNotifier {
  final TextEditingController firstNameCntlr = TextEditingController();
  final TextEditingController lastNameCntlr = TextEditingController();
  final TextEditingController emailCntlr = TextEditingController();
  final TextEditingController passwordCntlr = TextEditingController();

  final firstNameKey = GlobalKey<FormState>();
  final lastNameKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  Gender? _gender;

  Gender? get gender => _gender;

  bool obscureText = true;

  // If true all signup fields input are valid.
  // Is used to eneable or disable the button.
  bool validForm = false;

  // If a specific form is valid or not.
  bool? validFirstNameForm = false;
  bool? validLastNameForm = false;
  bool? validEmailForm = false;
  bool? validPasswordForm = false;

  // Checks if the all the form fields are valid.
  void validateForm() {
    if (validFirstNameForm == true &&
        validLastNameForm == true &&
        validEmailForm == true &&
        validPasswordForm == true) {
      validForm = true;
    } else {
      validForm = false;
    }
  }

  // Toggels the visablity of the password field  and icon.
  void togglePasswordView() {
    obscureText = !obscureText;
    notifyListeners();
  }

  // Set the selected gender
  void setGender({required dynamic value}) {
    _gender = value;
    notifyListeners();
  }

  // Validation of specific textfields
  bool? validateFirstNameForm() {
    final isValid = firstNameKey.currentState?.validate();
    validFirstNameForm = isValid;
    validateForm();
    notifyListeners();
    return isValid;
  }

  bool? validateLastNameForm() {
    final isValid = lastNameKey.currentState?.validate();
    validLastNameForm = isValid;
    validateForm();
    notifyListeners();
    return isValid;
  }

  bool? validateEmailForm() {
    final isValid = emailKey.currentState?.validate();
    validEmailForm = isValid;
    validateForm();
    notifyListeners();
    return isValid;
  }

  bool? validatePassword() {
    final isValid = passwordKey.currentState?.validate();
    validPasswordForm = isValid;
    validateForm();
    notifyListeners();
    return isValid;
  }

  // Resets the sign up process.
  void close() {
    emailCntlr.text = '';
    firstNameCntlr.text = '';
    lastNameCntlr.text = '';
    passwordCntlr.text = '';
    _gender = null;
    validForm = false;
    validFirstNameForm = false;
    validLastNameForm = false;
    validEmailForm = false;
    validPasswordForm = false;

    firstNameKey.currentState?.reset();
    lastNameKey.currentState?.reset();
    emailKey.currentState?.reset();
    passwordKey.currentState?.reset();
  }
}
