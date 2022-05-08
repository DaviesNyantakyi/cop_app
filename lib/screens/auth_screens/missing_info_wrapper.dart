import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/date_picker_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/gender_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/info_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/sign_up_flow/signup_flow.dart';
import 'package:cop_belgium_app/screens/bottom_nav_selector.dart';
import 'package:cop_belgium_app/screens/church_selection_screen/church_selection_screen.dart';
import 'package:cop_belgium_app/screens/profile_picker_screen.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';

import 'package:cop_belgium_app/widgets/custom_error_widget.dart';

import 'package:flutter/material.dart';

// This widget checks if any user inforamtion is missing.
class MissignInfoWrapper extends StatefulWidget {
  const MissignInfoWrapper({Key? key}) : super(key: key);

  @override
  State<MissignInfoWrapper> createState() => _MissignInfoWrapperState();
}

class _MissignInfoWrapperState extends State<MissignInfoWrapper> {
  final autStream = CloudFire().userStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: autStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('ok');
        }
        // return the BottomeNavScreen if no user inforamtion is missing.
        if (snapshot.hasData &&
            snapshot.data?.firstName != null &&
            snapshot.data?.lastName != null &&
            snapshot.data?.email != null &&
            snapshot.data?.dateOfBirth != null &&
            snapshot.data?.gender != null &&
            snapshot.data?.church != null) {
          return const BottomNavScreen();
        }

        if (snapshot.hasData) {
          return const _SignUpFlow();
        }
        return const Center(child: kCircularProgressIndicator);
      },
    );
  }
}

class _SignUpFlow extends StatefulWidget {
  const _SignUpFlow({Key? key}) : super(key: key);

  @override
  State<_SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends State<_SignUpFlow> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SignUpPageFlow(
      controller: controller,
      children: [
        AddInfoView(
          onSubmit: () {},
        ),
        DatePickerView(
          onWillPop: () async {
            return false;
          },
          onSubmit: () {},
        ),
        GenderView(
          onSubmit: () {},
        ),
        ChurchSelectionScreen(
          onTap: (selectedChurch) {},
        ),
        ProfilePickerScreen(
          onWillPop: () async {
            return false;
          },
          onSubmit: () {},
        ),
      ],
    );
  }
}
