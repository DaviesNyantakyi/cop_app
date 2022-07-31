import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/providers/audio_provider.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/screens/auth_screens/welcome_screen.dart';
import 'package:cop_belgium_app/screens/library_screen/library_screen.dart';
import 'package:cop_belgium_app/screens/more_screen/about_church_screen.dart';
import 'package:cop_belgium_app/screens/more_screen/settings_screen.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/avatar.dart';
import '../profile_screen/profile_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final firebaseAuth = FirebaseAuth.instance;

  late final userStream = CloudFire().getUserStream(
    uid: FirebaseAuth.instance.currentUser!.uid,
  );

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    setState(() {});
  }

  Future<void> logout() async {
    try {
      await Provider.of<AudioProvider>(context, listen: false).close();
      await FireAuth().signOut();
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

  Future<void> navigateToScreen() async {
    // Go to the welcome screen if the user is anonymous
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    if (firebaseAuth.currentUser?.isAnonymous == true) {
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider<SignUpProvider>.value(
            value: signUpProvider,
            child: const WelcomeScreen(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider<SignUpProvider>.value(
                value: signUpProvider,
              ),
            ],
            child: const ProfileScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(builder: (context, audioProvider, _) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: kContentSpacing16,
          ),
          child: Column(
            children: [
              _buildProfileTile(),
              const Divider(),
              Column(
                children: [
                  _buildTile(
                    title: 'Library',
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider<AudioProvider>.value(
                                value: audioProvider,
                              )
                            ],
                            child: const LibraryScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildTile(
                    title: 'About Church',
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AboutChruchScreen(),
                        ),
                      );
                    },
                  ),
                  _buildTile(
                    title: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildTile(
                    title: 'Logout',
                    onTap: logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: Text(
        'More',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildTile({required String title, required VoidCallback onTap}) {
    return SizedBox(
      height: kButtonHeight,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: kContentSpacing16),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(kRadius),
        //   ),
        // ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildProfileTile() {
    return CustomElevatedButton(
      padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomAvatar(radius: 30),
            const SizedBox(width: kContentSpacing12),
            _buildUserInfo(),
          ],
        ),
      ),
      onPressed: () => navigateToScreen(),
    );
  }

  Widget _buildUserInfo() {
    return StreamBuilder<UserModel?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firebaseAuth.currentUser?.isAnonymous == true
                    ? 'Sign In or Sign Up'
                    : snapshot.data?.displayName ??
                        firebaseAuth.currentUser?.displayName ??
                        'user',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: kBlack),
              ),
              firebaseAuth.currentUser?.isAnonymous == true
                  ? Container()
                  : const SizedBox(height: kContentSpacing4),
              firebaseAuth.currentUser?.isAnonymous == true
                  ? Container()
                  : Text(
                      snapshot.data?.church?['churchName'] ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: kBlack),
                    ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
