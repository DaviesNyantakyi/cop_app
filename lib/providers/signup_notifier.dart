import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth_screens/sign_up_flow/gender_view.dart';

enum FormType {
  signInForm,
  signupForm,
  missingInfoForm,
  forgotEmailForm,
  updateInfoForm
}
enum Gender { male, female }

class SignUpNotifier extends ChangeNotifier {
  final FireAuth _fireAuth = FireAuth();
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

  void setDateOfBirth({required DateTime value}) {
    _dateOfBirth = value.toUtc();
    notifyListeners();
  }

  void setGender({required dynamic value}) {
    _selectedGender = value;
    notifyListeners();
  }

  void setSelectedChurch({required ChurchModel value}) {
    _selectedChurch = value;
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
}
