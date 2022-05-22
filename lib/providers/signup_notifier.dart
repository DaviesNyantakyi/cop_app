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
  TextEditingController passwordCntlr = TextEditingController();

  final _firstNameKey = GlobalKey<FormState>();
  final _lastNameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  String? _displayName;
  bool validForm = false;
  DateTime? _dateOfBirth;

  GlobalKey<FormState> get firstNameKey => _firstNameKey;
  GlobalKey<FormState> get lastNameKey => _lastNameKey;
  GlobalKey<FormState> get emailKey => _emailKey;
  GlobalKey<FormState> get passwordKey => _passwordKey;
  String? get displayName => _displayName;
  DateTime? get dateOfBirth => _dateOfBirth;

  // if the form is valid or not
  void validateForm({required bool value}) {
    validForm = value;
    notifyListeners();
  }

  // Set the display name
  void setDisplayName() {
    _displayName = '${firstNameCntlr.text.trim()} ${lastNameCntlr.text.trim()}';
    notifyListeners();
  }

  // Set the selected date of birth.
  void setDateOfBirth({required DateTime value}) {
    _dateOfBirth = value.toUtc();
    notifyListeners();
  }
}
