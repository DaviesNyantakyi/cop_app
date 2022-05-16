import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/gender_view.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/enum_to_string.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum FormType {
  signInForm,
  signupForm,
  missingInfoForm,
  forgotEmailForm,
  updateInfoForm
}

class SignUpNotifier extends ChangeNotifier {
  TextEditingController firstNameCntlr = TextEditingController();
  TextEditingController lastNameCntlr = TextEditingController();
  TextEditingController emailCntlr = TextEditingController();
  TextEditingController forgotEmailCntlr = TextEditingController();
  TextEditingController passwordCntlr = TextEditingController();

  final firstNameKey = GlobalKey<FormState>();
  final lastNameKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final forgotEmailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  final FireAuth _fireAuth = FireAuth();
  final CloudFire _cloudFire = CloudFire();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DateTime? _dateOfBirth;
  Gender? _selectedGender;
  String? _dateOfBirthErrorText;
  String? _displayName;
  String? _photoURL;
  String? _bio;
  FormType? _formeState;

  bool obscureText = true;

  // If a specific form is valid or not.
  bool? firstNameFormIsValid = false;
  bool? lastNameFormIsValid = false;
  bool? emailFormIsValid = false;
  bool? forgotEmailFormIsValid = false;
  bool? passwordFormIsValid = false;
  bool _dateOfBirthIsValid = false;
  // If true all signup fields input are valid.
  bool validForm = false;

  ChurchModel? _selectedChurch;

  Gender? get selectedGender => _selectedGender;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get errorText => _dateOfBirthErrorText;
  String? get displayName => _displayName;
  bool get dateOfBirthIsValid => _dateOfBirthIsValid;
  ChurchModel? get selectedChurch => _selectedChurch;
  String? get photoUrl => _photoURL;
  String? get bio => _bio;
  FormType? get formType => _formeState;

  // Checks if the all the form fields are valid.
  void validateForm() {
    if (_formeState == FormType.signInForm) {
      if (emailFormIsValid == true && passwordFormIsValid == true) {
        validForm = true;
      } else {
        validForm = false;
      }
    }
    if (_formeState == FormType.forgotEmailForm) {
      if (forgotEmailFormIsValid == true) {
        validForm = true;
      } else {
        validForm = false;
      }
    }

    if (_formeState == FormType.signupForm) {
      if (firstNameFormIsValid == true &&
          lastNameFormIsValid == true &&
          emailFormIsValid == true &&
          passwordFormIsValid == true) {
        validForm = true;
      } else {
        validForm = false;
      }
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
  void setFormType({required FormType formType}) {
    _formeState = formType;
    notifyListeners();
  }

  // Set the selected gender
  void setSelectedChurch({required ChurchModel value}) {
    _selectedChurch = value;
    notifyListeners();
  }

  // Set the selected date of birth.
  void setDateOfBirth({required DateTime value}) {
    _dateOfBirth = value;
    notifyListeners();
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
          selectedChurch != null &&
          _dateOfBirth != null) {
        final user = UserModel(
          firstName: firstNameCntlr.text.trim(),
          lastName: lastNameCntlr.text.trim(),
          displayName: _displayName ??
              '${firstNameCntlr.text.trim()} ${lastNameCntlr.text.trim()}',
          dateOfBirth: Timestamp.fromMillisecondsSinceEpoch(
              _dateOfBirth!.millisecondsSinceEpoch),
          email: emailCntlr.text.trim(),
          gender: enumToString(object: _selectedGender),
          church: {
            'id': selectedChurch!.id,
            'churchName': selectedChurch!.churchName
          },
        );

        return await _fireAuth.createUserEmailPassword(
          user: user,
          password: passwordCntlr.text,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signIn() async {
    try {
      if (emailCntlr.text.isNotEmpty && passwordCntlr.text.isNotEmpty) {
        await _fireAuth.loginEmailPassword(
          email: emailCntlr.text.trim(),
          password: passwordCntlr.text,
        );
        return _firebaseAuth.currentUser;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendPasswordResetEmail() async {
    try {
      if (forgotEmailFormIsValid == true && forgotEmailCntlr.text.isNotEmpty) {
        return await _fireAuth.sendPasswordResetEmail(
          email: forgotEmailCntlr.text.trim(),
        );
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateInfo() async {
    try {
      if (firstNameCntlr.text.isNotEmpty && lastNameCntlr.text.isNotEmpty) {
        await _cloudFire.updateUsername(
          lastName: lastNameCntlr.text.trim(),
          firstName: firstNameCntlr.text.trim(),
        );
      }

      await _cloudFire.updateUserGender(
        gender: enumToString(object: _selectedGender),
      );
      if (_selectedChurch != null) {
        await _cloudFire.updateUserChurch(
          id: _selectedChurch!.id!,
          churchName: _selectedChurch!.churchName,
        );
      }
      if (_dateOfBirth != null) {
        await _cloudFire.updateUserDateOfBirth(dateOfBirth: _dateOfBirth!);
      }
      await _cloudFire.updateBio(bio: _bio);
      await _cloudFire.updatePhotoURL(photoURL: _photoURL);

      return true;
    } catch (e) {
      rethrow;
    }
  }

  // Resets the sign up process.
  void resetForm() {
    emailCntlr.text = '';
    forgotEmailCntlr.text = '';
    firstNameCntlr.text = '';
    lastNameCntlr.text = '';
    passwordCntlr.text = '';
    _displayName = '';

    _bio = null;
    _photoURL = null;
    _formeState = null;
    _selectedGender = null;
    _dateOfBirthErrorText = null;
    _dateOfBirthIsValid = false;
    validForm = false;
    firstNameFormIsValid = false;
    lastNameFormIsValid = false;
    emailFormIsValid = false;
    forgotEmailFormIsValid = false;
    passwordFormIsValid = false;
    obscureText = true;

    _dateOfBirth = DateTime.now();
    firstNameKey.currentState?.reset();
    lastNameKey.currentState?.reset();
    emailKey.currentState?.reset();
    passwordKey.currentState?.reset();
    forgotEmailKey.currentState?.reset();
  }
}
