import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorCodes {
  final String defaultErrorMessage = 'Something went wrong.';

  String firebaseMessages({required FirebaseException e}) {
    if (e.message ==
        'The caller does not have permission to execute the specified operation.') {
      return defaultErrorMessage;
    }
    if (e.message == 'User is not authorized to perform the desired action.') {
      return defaultErrorMessage;
    }
    return e.message ?? defaultErrorMessage;
  }
}
