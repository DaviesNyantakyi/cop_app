import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/screens/auth_screens/gender_view.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
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

  DateTime _dateOfBirth = DateTime.now();
  Gender? _gender;
  String? _dateOfBirthErrorText;

  bool obscureText = true;

  // If a specific form is valid or not.
  bool? firstNameFormIsValid = false;
  bool? lastNameFormIsValid = false;
  bool? emailFormIsValid = false;
  bool? passwordFormIsValid = false;
  bool _dateOfBirthIsValid = false;
  // If true all signup fields input are valid.
  bool infoFormIsValid = false;

  ChurchModel? _churchModel;

  Gender? get gender => _gender;
  DateTime get dateOfBirth => _dateOfBirth;
  String? get errorText => _dateOfBirthErrorText;
  bool get dateOfBirthIsValid => _dateOfBirthIsValid;
  ChurchModel? get churchModel => _churchModel;

  // Checks if the all the form fields are valid.
  void validateForm() {
    if (firstNameFormIsValid == true &&
        lastNameFormIsValid == true &&
        emailFormIsValid == true &&
        passwordFormIsValid == true) {
      infoFormIsValid = true;
    } else {
      infoFormIsValid = false;
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

  // Set the selected gender
  void setSelectedChurch({required ChurchModel value}) {
    _churchModel = value;
    notifyListeners();
  }

  // Set the selected date of birth.
  void setDateOfBirth({required DateTime value}) {
    _dateOfBirth = value;
    notifyListeners();
  }

  // Validation of specific textfields
  bool? validateFirstNameForm() {
    final isValid = firstNameKey.currentState?.validate();
    firstNameFormIsValid = isValid;
    validateForm();
    notifyListeners();
    return isValid;
  }

  bool? validateLastNameForm() {
    final isValid = lastNameKey.currentState?.validate();
    lastNameFormIsValid = isValid;
    validateForm();
    notifyListeners();
    return isValid;
  }

  bool? validateEmailForm() {
    final isValid = emailKey.currentState?.validate();
    emailFormIsValid = isValid;
    validateForm();
    notifyListeners();
    return isValid;
  }

  bool? validatePassword() {
    final isValid = passwordKey.currentState?.validate();
    passwordFormIsValid = isValid;
    validateForm();
    notifyListeners();
    return isValid;
  }

  void validateDate() {
    DateTime today = DateTime.now();

    _dateOfBirthErrorText = Validators.birthdayValidator(
      date: _dateOfBirth,
    );

    // The form is valid if there is no error text and
    // if the selectedDate's year is smaller then current year.
    if (errorText == null && _dateOfBirth.year < today.year) {
      _dateOfBirthIsValid = true;
    } else {
      _dateOfBirthIsValid = false;
    }
    notifyListeners();
  }

  Future<void> signUp() async {}

  // Resets the sign up process.
  void close() {
    emailCntlr.text = '';
    firstNameCntlr.text = '';
    lastNameCntlr.text = '';
    passwordCntlr.text = '';
    _gender = null;
    infoFormIsValid = false;
    firstNameFormIsValid = false;
    lastNameFormIsValid = false;
    emailFormIsValid = false;
    passwordFormIsValid = false;
    _dateOfBirthErrorText = null;
    obscureText = true;
    _dateOfBirth = DateTime.now();

    firstNameKey.currentState?.reset();
    lastNameKey.currentState?.reset();
    emailKey.currentState?.reset();
    passwordKey.currentState?.reset();
  }
}
