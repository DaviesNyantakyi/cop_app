import 'package:cop_belgium_app/providers/audio_provider.dart';
import 'package:cop_belgium_app/screens/auth_screens/missing_info_wrapper.dart';
import 'package:cop_belgium_app/screens/auth_screens/welcome_screen.dart';
import 'package:cop_belgium_app/screens/bottom_nav_screen.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/widgets/error_widget.dart';
import 'package:cop_belgium_app/widgets/circular_progress_indicator.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  static String authScreenSwitcher = 'authScreenSwitcher';
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
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
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('AppLifecycleState Resumed');
        break;
      case AppLifecycleState.inactive:
        debugPrint('AppLifecycleState Inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('AppLifecycleState Paused');
        break;
      case AppLifecycleState.detached:
        await Provider.of<AudioProvider>(context, listen: false).close();
        debugPrint('AppLifecycleState Detached');
        break;
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
