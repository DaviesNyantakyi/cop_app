import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionNotifier extends ChangeNotifier {
  bool hasConnection = false;

  Future<void> intializeConnectionChecker() async {
    InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) async {
      await checkConnection();
    });
    await checkConnection();
  }

  Future<bool> checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result == false) {
      throw connectionException;
    }
    hasConnection = result;
    notifyListeners();
    return result;
  }

  static FirebaseException connectionException = FirebaseException(
    plugin: 'Connection Checker:',
    code: 'No connection',
    message:
        'No internet connection. Make sure your wifi or cellular data is turned on',
  );
}
