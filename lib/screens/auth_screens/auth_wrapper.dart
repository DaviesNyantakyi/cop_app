import 'package:cop_belgium_app/screens/auth_screens/welcome_screen.dart';
import 'package:cop_belgium_app/screens/bottom_nav_selector.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  static String authScreenSwitcher = 'authScreenSwitcher';
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final authChanges = FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authChanges,
      builder: (context, snaphot) {
        if (snaphot.connectionState == ConnectionState.active) {
          if (snaphot.hasData &&
              snaphot.data?.uid != null &&
              snaphot.data != null) {
            return const BottomNavScreen();
          }

          return const WelcomeScreen();
        } else {
          return const Scaffold(
            body: Center(
              child: kCircularProgressIndicator,
            ),
          );
        }
      },
    );
  }
}
