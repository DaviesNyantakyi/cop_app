import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum FormType {
  signInForm,
  signupForm,
  missingInfoForm,
  forgotEmailForm,
  updateInfoForm
}

enum Gender { male, female }

class SignUpProvider extends ChangeNotifier {
  final FireAuth _fireAuth = FireAuth();
  final CloudFire _cloudFire = CloudFire();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController firstNameCntlr = TextEditingController();
  TextEditingController lastNameCntlr = TextEditingController();
  TextEditingController emailCntlr = TextEditingController();
  TextEditingController passwordCntlr = TextEditingController();

  final _firstNameKey = GlobalKey<FormState>();
  final _lastNameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  String? _displayName;
  bool _formIsValid = false;
  bool _dateOfBirthIsValid = false;
  DateTime? _dateOfBirth;
  Gender? _selectedGender;
  ChurchModel? _selectedChurch;

  GlobalKey<FormState> get firstNameKey => _firstNameKey;
  GlobalKey<FormState> get lastNameKey => _lastNameKey;
  String? get displayName => _displayName;
  GlobalKey<FormState> get emailKey => _emailKey;
  GlobalKey<FormState> get passwordKey => _passwordKey;
  bool get formIsValid => _formIsValid;
  DateTime? get dateOfBirth => _dateOfBirth;
  bool get dateOfBirthIsValid => _dateOfBirthIsValid;
  Gender? get selectedGender => _selectedGender;
  ChurchModel? get selectedChurch => _selectedChurch;

  // if the form is valid or not
  void validateForm({required bool value}) {
    _formIsValid = value;
    notifyListeners();
  }

  void validateDateOfBirth({required bool value}) {
    _dateOfBirthIsValid = value;
    notifyListeners();
  }

  void setDisplayName() {
    _displayName = '${firstNameCntlr.text.trim()} ${lastNameCntlr.text.trim()}';
    notifyListeners();
  }

  void setEmail({required String email}) {
    emailCntlr.text = email;
    notifyListeners();
  }

  void setDateOfBirth({required DateTime value}) {
    _dateOfBirth = value;
    notifyListeners();
  }

  void setGender({required Gender value}) {
    _selectedGender = value;
    notifyListeners();
  }

  void setSelectedChurch({required ChurchModel value}) {
    _selectedChurch = value;
    notifyListeners();
  }

  Future<bool?> signUp() async {
    try {
      if (firstNameCntlr.text.isNotEmpty &&
          lastNameCntlr.text.isNotEmpty &&
          emailCntlr.text.isNotEmpty &&
          _selectedGender != null &&
          selectedChurch != null &&
          _dateOfBirth != null) {
        final displayName =
            '${firstNameCntlr.text.trim()} ${lastNameCntlr.text.trim()}';
        final user = UserModel(
          id: _firebaseAuth.currentUser?.uid,
          firstName: firstNameCntlr.text.trim(),
          lastName: lastNameCntlr.text.trim(),
          displayName: _displayName?.trim() ?? displayName,
          dateOfBirth: Timestamp.fromMillisecondsSinceEpoch(
            _dateOfBirth!.millisecondsSinceEpoch,
          ),
          email: emailCntlr.text.trim(),
          gender: EnumToString.convertToString(_selectedGender),
          church: {
            'id': selectedChurch!.id,
            'churchName': selectedChurch!.churchName
          },
        );

        await _fireAuth.createUserEmailPassword(
          userModel: user,
          password: passwordCntlr.text,
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool?> updateUpdateInfo() async {
    try {
      if (firstNameCntlr.text.isNotEmpty &&
          lastNameCntlr.text.isNotEmpty &&
          emailCntlr.text.isNotEmpty &&
          _selectedGender != null &&
          selectedChurch != null &&
          _dateOfBirth != null) {
        await _fireAuth.updateDisplayName(
          firstName: firstNameCntlr.text,
          lastName: lastNameCntlr.text,
        );

        await _cloudFire.updateUserDateOfBirth(
          dateOfBirth: Timestamp.fromDate(_dateOfBirth!),
        );

        final gender = EnumToString.convertToString(_selectedGender);

        await _cloudFire.updateUserGender(
          gender: gender,
        );

        await _cloudFire.updateUserChurch(
          id: _selectedChurch!.id!,
          churchName: _selectedChurch!.churchName,
        );
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  void close() {
    firstNameCntlr.clear();
    lastNameCntlr.clear();
    emailCntlr.clear();
    passwordCntlr.clear();

    _firstNameKey.currentState?.reset();
    _lastNameKey.currentState?.reset();
    _emailKey.currentState?.reset();
    _passwordKey.currentState?.reset();

    _displayName = null;
    _formIsValid = false;
    _dateOfBirthIsValid = false;
    _dateOfBirth = null;
    _selectedGender = null;
    _selectedChurch = null;
  }
}
