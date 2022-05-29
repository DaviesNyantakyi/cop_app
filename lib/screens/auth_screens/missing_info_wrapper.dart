import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/auth_screens/missing_info_page_view.dart';
import 'package:cop_belgium_app/screens/home_screen.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/services/fire_auth.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';

class MissingInfoWrapper extends StatefulWidget {
  const MissingInfoWrapper({Key? key}) : super(key: key);

  @override
  State<MissingInfoWrapper> createState() => _MissingInfoWrapperState();
}

class _MissingInfoWrapperState extends State<MissingInfoWrapper> {
  final autStream = CloudFire().getUserStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: autStream,
      builder: (context, snapshot) {
        // Sign out the user if ther is a error.
        if (snapshot.hasError) {
          return CustomErrorWidget(
            onPressed: () {
              FireAuth().signOut();
            },
          );
        }

        // return the HomeScreen if there is no inforamtion missing.
        if (snapshot.hasData &&
            snapshot.data?.firstName != null &&
            snapshot.data?.lastName != null &&
            snapshot.data?.displayName != null &&
            snapshot.data?.email != null &&
            snapshot.data?.dateOfBirth != null &&
            snapshot.data?.gender != null &&
            snapshot.data?.church != null) {
          return const HomeScreen();
        }

        if (snapshot.hasData) {
          return const MissingInfoPageView();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
