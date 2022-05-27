import 'package:cop_belgium_app/screens/auth_screens/missing_info_wrapper.dart';
import 'package:cop_belgium_app/screens/auth_screens/welcome_screen.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';
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
    return StreamBuilder<User?>(
      stream: authChanges,
      builder: (context, snapshot) {
        // When there is an error logout user
        if (snapshot.hasError) {
          return CustomErrorWidget(
            onPressed: () async {
              FireAuth().signOut();
            },
          );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          // return the Infowrapper if the date is not null or loading

          if (snapshot.hasData &&
              snapshot.data?.uid != null &&
              snapshot.data != null) {
            return const MissingInfoWrapper();
          }

          //return the welcomeScreen if the user is logged out or the user object is null.
          return const WelcomeScreen();
        } else {
          // show a progress indicator if the snaphot data is loading.
          return const Scaffold(
            body: Center(
              child: CustomCircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
