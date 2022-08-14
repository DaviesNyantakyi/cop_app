import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/date_picker.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../services/cloud_fire.dart';
import '../../utilities/formal_dates.dart';

class EditDateScreen extends StatefulWidget {
  const EditDateScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditDateScreen> createState() => _EditDateScreenState();
}

class _EditDateScreenState extends State<EditDateScreen> {
  final _cloudFire = CloudFire();
  final firebaseAuth = FirebaseAuth.instance;

  final currentDate = DateTime.now();
  late SignUpProvider signUpProvider;
  UserModel? user;
  String? dateOfBirthErrorText;

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.close();
    super.dispose();
  }

  Future<void> init() async {
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    user = await CloudFire().getUser(id: firebaseAuth.currentUser?.uid);
    if (user?.dateOfBirth?.toDate() != null) {
      signUpProvider.setDateOfBirth(value: user!.dateOfBirth!.toDate());
    }

    validDateBirthDate();

    setState(() {});
  }

  Future<void> update() async {
    try {
      signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (signUpProvider.dateOfBirth?.year != null &&
          signUpProvider.dateOfBirth!.year < currentDate.year) {
        EasyLoading.show();

        await _cloudFire.updateUserDateOfBirth(
            dateOfBirth: Timestamp.fromDate(signUpProvider.dateOfBirth!));
        if (hasConnection) {
        } else {
          throw ConnectionNotifier.connectionException;
        }
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

  void validDateBirthDate() {
    if (signUpProvider.dateOfBirth == null) {
      signUpProvider.validateDateOfBirth(value: false);
    }

    if (signUpProvider.dateOfBirth != null) {
      if (signUpProvider.dateOfBirth!.year < currentDate.year) {
        signUpProvider.validateDateOfBirth(value: true);
      } else {
        signUpProvider.validateDateOfBirth(value: false);
      }
    }
    setState(() {});
  }

  Future<void> showDatePicker() async {
    await showCustomDatePicker(
      initialDateTime: signUpProvider.dateOfBirth ?? DateTime.now(),
      maxDate: DateTime.now(),
      mode: CupertinoDatePickerMode.date,
      context: context,
      isDismissible: true,
      onChanged: (date) {
        signUpProvider.setDateOfBirth(value: date);
        dateOfBirthErrorText = Validators.birthdayValidator(
          date: date,
        );
        validDateBirthDate();
      },
    );
    validDateBirthDate();
    dateOfBirthErrorText = Validators.birthdayValidator(
      date: signUpProvider.dateOfBirth,
    );
    setState(() {});
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
              _datePicker(),
              const SizedBox(height: kContentSpacing32),
              _buildContinueButton()
            ],
          ),
        ),
      ),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text('Date of birth',
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
      question = 'What\'s your date of birth,';
      displayName = Text(
        '${user?.displayName?.trim() ?? firebaseAuth.currentUser?.displayName}?',
        style: Theme.of(context).textTheme.headline5,
      );
    } else {
      question = 'What\'s your date of birth?';
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

  Consumer _datePicker() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomElevatedButton(
              height: kButtonHeight,
              side: BorderSide(
                color: signUpProvider.dateOfBirth != null &&
                        signUpProvider.dateOfBirthIsValid == true
                    ? kBlue
                    : kGrey,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kContentSpacing8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      BootstrapIcons.calendar,
                      color: kBlack,
                      size: kIconSize,
                    ),
                    const SizedBox(width: kContentSpacing8),
                    Text(
                      FormalDates.formatDmyyyy(
                            date: signUpProvider.dateOfBirth?.toLocal(),
                          ) ??
                          FormalDates.formatDmyyyy(
                            date: DateTime.now().toLocal(),
                          ) ??
                          '',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              onPressed: showDatePicker,
            ),
            Validators().showValidationWidget(
              context: context,
              errorText: dateOfBirthErrorText,
            )
          ],
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return CustomElevatedButton(
          height: kButtonHeight,
          width: double.infinity,
          backgroundColor: signUpProvider.dateOfBirth != null &&
                  signUpProvider.dateOfBirthIsValid == true
              ? kBlue
              : kGrey,
          child: Text(
            'Update',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: kWhite,
                ),
          ),
          onPressed: signUpProvider.dateOfBirth != null &&
                  signUpProvider.dateOfBirthIsValid == true
              ? update
              : null,
        );
      },
    );
  }
}
