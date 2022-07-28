import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/gender_button.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/cloud_fire.dart';

class EditGenderScreen extends StatefulWidget {
  const EditGenderScreen({Key? key}) : super(key: key);

  @override
  State<EditGenderScreen> createState() => _EditGenderScreenState();
}

class _EditGenderScreenState extends State<EditGenderScreen> {
  final _cloudFire = CloudFire();
  final firebaseAuth = FirebaseAuth.instance;
  late SignUpProvider signUpProvider;
  UserModel? user;

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    init();

    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.close();
    super.dispose();
  }

  Future<void> init() async {
    user = await CloudFire().getUser(id: firebaseAuth.currentUser?.uid);
    if (user?.gender != null) {
      Gender gender;
      if (user?.gender == 'male') {
        gender = Gender.male;
      } else {
        gender = Gender.female;
      }

      signUpProvider.setGender(value: gender);
    }

    setState(() {});
  }

  Future<void> update() async {
    try {
      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (hasConnection) {
        EasyLoading.show();

        await _cloudFire.updateUserGender(
          gender: EnumToString.convertToString(signUpProvider.selectedGender),
        );
      } else {
        throw ConnectionNotifier.connectionException;
      }
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());

      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: kContentSpacing16,
            vertical: kContentSpacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderText(),
              const SizedBox(height: kContentSpacing24),
              _buildGenderButtons(),
              const SizedBox(height: kContentSpacing32),
              _buildUpdateButton()
            ],
          ),
        ),
      ),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text('Gender',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHeaderText() {
    final headerStyle = Theme.of(context).textTheme.headline5;

    String question;
    Widget? displayName;

    if (user?.displayName != null) {
      question = 'What\'s your gender,';
      displayName = Text(
        '${user?.displayName?.trim() ?? firebaseAuth.currentUser?.displayName}?',
        style: Theme.of(context).textTheme.headline5,
      );
    } else {
      question = 'What\'s your gender?';
      displayName = Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: headerStyle,
        ),
        displayName
      ],
    );
  }

  Widget _buildGenderButtons() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return Row(
          children: [
            Expanded(
              child: GenderContianer(
                value: Gender.male,
                groupsValue: signUpProvider.selectedGender,
                title: 'Male',
                image: 'assets/images/male.png',
                onChanged: (value) {
                  signUpProvider.setGender(value: value);
                },
              ),
            ),
            const SizedBox(width: kContentSpacing8),
            Expanded(
              child: GenderContianer(
                value: Gender.female,
                groupsValue: signUpProvider.selectedGender,
                title: 'Female',
                image: 'assets/images/female.png',
                onChanged: (value) {
                  signUpProvider.setGender(value: value);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpdateButton() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        final gender = signUpProvider.selectedGender;
        return CustomElevatedButton(
          height: kButtonHeight,
          width: double.infinity,
          backgroundColor: gender != null ? kBlue : kGreyLight,
          child: Text(
            'Update',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: gender != null ? kWhite : kGrey),
          ),
          onPressed: gender != null ? update : null,
        );
      },
    );
  }
}
