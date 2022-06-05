import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/welcome_screen.dart';
import 'package:cop_belgium_app/screens/testimonies_screens/testimonies_screen.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final firebaseAuth = FirebaseAuth.instance;

  late SignUpNotifier signUpNotifier;
  late final userStream = CloudFire().getUserStream();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    setState(() {});
  }

  Future<void> logout() async {
    try {
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

  void navigateToScreen({required Widget screen}) {
    if (firebaseAuth.currentUser?.isAnonymous == true) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider<SignUpNotifier>.value(
            value: signUpNotifier,
            child: const WelcomeScreen(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => screen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: kContentSpacing24,
          horizontal: kContentSpacing24,
        ),
        child: Column(
          children: [
            _buildProfileTile(),
            const SizedBox(height: kContentSpacing24),
            const Divider(),
            _buildTile(
              title: 'Testimonies',
              onTap: () => navigateToScreen(screen: const TestimoniesScreen()),
            ),
            _buildTile(
              title: 'Request Baptism',
              onTap: () {},
            ),
            const Divider(),
            _buildTile(
              title: 'About Church',
              onTap: () {},
            ),
            _buildTile(
              title: 'Settings',
              onTap: () {},
            ),
            _buildTile(
              title: 'Logout',
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: Text(
        'More',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _buildTile({required String title, required VoidCallback onTap}) {
    return SizedBox(
      height: kButtonHeight,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(kRadius),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAvatar() {
    final user = firebaseAuth.currentUser;

    ImageProvider<Object>? backgroundImage;
    Widget child = const Icon(
      Icons.person_outline_outlined,
      color: kBlack,
    );

    if (user != null && user.photoURL != null) {
      backgroundImage = CachedNetworkImageProvider(user.photoURL!);
      child = Container();
    }
    return CircleAvatar(
      radius: 28,
      backgroundColor: kGreyLight,
      child: child,
      backgroundImage: backgroundImage,
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
                    : firebaseAuth.currentUser?.displayName ?? '',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              firebaseAuth.currentUser?.isAnonymous == true
                  ? Container()
                  : const SizedBox(height: kContentSpacing4),
              firebaseAuth.currentUser?.isAnonymous == true
                  ? Container()
                  : Text(
                      snapshot.data?.church?['churchName'] ?? '',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _buildProfileTile() {
    return GestureDetector(
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: kContentSpacing12),
            _buildUserInfo(),
          ],
        ),
      ),
      onTap: () => navigateToScreen(screen: const ProfileScreen()),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context: context),
        body: SingleChildScrollView(
          child: Container(),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar({required BuildContext context}) {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text(
        'Profile',
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: [
        CustomElevatedButton(
          child: Text(
            'Edit profile',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
