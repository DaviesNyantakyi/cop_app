import 'package:cop_belgium_app/screens/auth_screens/missing_info_screens/info_wrapper.dart';
import 'package:cop_belgium_app/screens/auth_screens/welcome_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();

    return StreamBuilder<User?>(
      stream: authChanges,
      builder: (context, snaphot) {
        // When there is an error show the error.
        if (snaphot.hasError) {
          return const CustomErrorWidget();
        }

        if (snaphot.connectionState == ConnectionState.active) {
          // return the Infowrapper if the date is not null or loading.
          if (snaphot.hasData &&
              snaphot.data?.uid != null &&
              snaphot.data != null) {
            return const InfoWrapper();
          }

          //return the welcomeScreen if the user is logged out or the user object is null.
          return const WelcomeScreen();
        } else {
          // show a progress indicator if the snaphot data is loading.
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
