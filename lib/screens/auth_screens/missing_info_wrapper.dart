import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/auth_screens/missing_info_page_view.dart';
import 'package:cop_belgium_app/screens/home_screen.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Somthing went wrong.');
        }

        if (snapshot.hasData &&
            snapshot.data?.gender != null &&
            snapshot.data?.firstName != null) {
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
