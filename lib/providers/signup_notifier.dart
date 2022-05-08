import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/gender_view.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/enum_to_string.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpNotifier extends ChangeNotifier {
  final FireAuth _auth = FireAuth();
  final TextEditingController firstNameCntlr = TextEditingController();
  final TextEditingController lastNameCntlr = TextEditingController();
  final TextEditingController emailCntlr = TextEditingController();
  final TextEditingController passwordCntlr = TextEditingController();

  final firstNameKey = GlobalKey<FormState>();
  final lastNameKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  DateTime? _dateOfBirth;
  Gender? _selectedGender;
  String? _dateOfBirthErrorText;
  String? _displayName;

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

  Gender? get selectedGender => _selectedGender;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get errorText => _dateOfBirthErrorText;
  String? get displayName => _displayName;
  bool get dateOfBirthIsValid => _dateOfBirthIsValid;
  ChurchModel? get _selectedChurch => _churchModel;

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
    _selectedGender = value;
    notifyListeners();
  }

  // Set the selected gender
  void setDisplayName() {
    _displayName = '${firstNameCntlr.text.trim()} ${lastNameCntlr.text.trim()}';
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

    if (_dateOfBirth != null) {
      // The form is valid if there is no error text and
      // if the selectedDate year is smaller then current year.
      if (errorText == null && _dateOfBirth!.year < today.year) {
        _dateOfBirthIsValid = true;
      } else {
        _dateOfBirthIsValid = false;
      }
    } else {
      _dateOfBirthIsValid = false;
    }
    notifyListeners();
  }

  Future<User?> signUp() async {
    try {
      if (firstNameCntlr.text.isNotEmpty &&
          lastNameCntlr.text.isNotEmpty &&
          _selectedChurch != null &&
          _dateOfBirth != null) {
        final user = UserModel(
          firstName: firstNameCntlr.text.trim(),
          lastName: lastNameCntlr.text.trim(),
          displayName: _displayName ??
              '${firstNameCntlr.text.trim()} ${lastNameCntlr.text.trim()}',
          dateOfBirth: _dateOfBirth!,
          email: emailCntlr.text.trim(),
          gender: enumToString(object: _selectedGender),
          church: {
            'id': _selectedChurch!.id,
            'churchName': _selectedChurch!.churchName
          },
        );

        return await _auth.createUserEmailPassword(
          user: user,
          password: passwordCntlr.text,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Resets the sign up process.
  void close() {
    emailCntlr.text = '';
    firstNameCntlr.text = '';
    lastNameCntlr.text = '';
    passwordCntlr.text = '';
    _displayName = '';

    _selectedGender = null;
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
