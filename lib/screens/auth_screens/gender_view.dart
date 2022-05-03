import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/gender_button.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Gender { male, female }

class GenderView extends StatefulWidget {
  const GenderView({Key? key}) : super(key: key);

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  Future<void> submit() async {
    bool hasConnection = await ConnectionChecker().checkConnection();

    if (hasConnection) {
      await Provider.of<PageController>(context, listen: false).nextPage(
        duration: kPagViewDuration,
        curve: kPagViewCurve,
      );
    } else {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: ConnectionChecker.connectionException.message ?? '',
      );
    }
  }

  Future<void> _previousPage() async {
    await Provider.of<PageController>(context, listen: false).previousPage(
      duration: kPagViewDuration,
      curve: kPagViewCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _previousPage();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(onPressed: () => _previousPage()),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: kContentSpacing16,
              vertical: kContentSpacing24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerText(),
                const SizedBox(height: kContentSpacing24),
                _genderButtons(),
                const SizedBox(height: kContentSpacing32),
                _continueButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _headerText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'What\'s your gender,',
          style: kFontH5,
        ),
        Text(
          'Eva Smith?',
          style: kFontH5,
        ),
      ],
    );
  }

  Widget _genderButtons() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        final gender = signUpNotifier.gender;
        return Row(
          children: [
            Expanded(
              child: GenderContianer(
                value: Gender.male,
                groupsValue: gender,
                title: 'Male',
                image: 'assets/images/male.png',
                onChanged: (value) {
                  signUpNotifier.setGender(value: value);
                },
              ),
            ),
            const SizedBox(width: kContentSpacing8),
            Expanded(
              child: GenderContianer(
                value: Gender.female,
                groupsValue: gender,
                title: 'Female',
                image: 'assets/images/female.png',
                onChanged: (value) {
                  signUpNotifier.setGender(value: value);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _continueButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        final gender = signUpNotifier.gender;
        return CustomElevatedButton(
          width: double.infinity,
          backgroundColor: kBlue,
          child: Text(
            'Continue',
            style: kFontBody.copyWith(color: gender != null ? kWhite : kGrey),
          ),
          onPressed: gender != null ? submit : null,
        );
      },
    );
  }
}
