import 'package:cop_belgium_app/screens/auth_screens/missing_info_wrapper.dart';
import 'package:cop_belgium_app/screens/auth_screens/welcome_screen.dart';
import 'package:cop_belgium_app/screens/bottom_nav_screen.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  static String authScreenSwitcher = 'authScreenSwitcher';
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final authChanges = FirebaseAuth.instance.authStateChanges();
  final fireAuth = FireAuth();

  Future<void> signOut() async {
    try {
      await fireAuth.signOut();
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authChanges,
      builder: (context, snapshot) {
        // When there is an error logout user
        if (snapshot.hasError) {
          return CustomErrorWidget(
            onPressed: signOut,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CustomCircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data?.isAnonymous == true) {
          return const BottomNavigationScreen();
        }

        if (snapshot.hasData &&
            snapshot.data?.uid != null &&
            snapshot.data != null) {
          return const MissingInfoWrapper();
        }

        //return the welcomeScreen if the user is logged out or the user object is null.
        return const WelcomeScreen();
      },
    );
  }
}
