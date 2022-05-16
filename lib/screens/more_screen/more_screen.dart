import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/screens/testimonies_screens/testimonies_screen.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future<void> logout() async {
    try {
      await FireAuth().logout();
    } on FirebaseAuthException catch (e) {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: e.message ?? '',
      );
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
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
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const TestimoniesScreen(),
                  ),
                );
              },
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
      title: const Text(
        'More',
        style: kFontH6,
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
          style: kFontBody,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAvatar() {
    final user = FirebaseAuth.instance.currentUser;

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
      radius: 36,
      backgroundColor: kGreyLight,
      child: child,
      backgroundImage: backgroundImage,
    );
  }

  Widget _buildUserInfo() {
    final userName = FirebaseAuth.instance.currentUser?.displayName;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userName ?? ' ',
          style: kFontBody,
        ),
        const SizedBox(height: kContentSpacing4),
        const Text(
          'Piwc Turnhout',
          style: kFontBody2,
        ),
      ],
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
      onTap: () async {},
    );
  }
}
