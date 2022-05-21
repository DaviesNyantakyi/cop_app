import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/page_navigation.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/gender_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Gender { male, female }

class GenderView extends StatefulWidget {
  final PageController pageController;

  const GenderView({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  Gender? gender;
  void onSubmit() {
    nextPage(controller: widget.pageController);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        previousPage(pageContoller: widget.pageController);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(
            onPressed: () {
              previousPage(pageContoller: widget.pageController);
            },
          ),
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

  Widget _headerText() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s your gender,',
              style: kFontH5,
            ),
            Text(
              '${signUpNotifier.firstNameCntlr.text.trim()}?',
              style: kFontH5,
            ),
          ],
        );
      },
    );
  }

  Widget _genderButtons() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return Row(
          children: [
            Expanded(
              child: GenderContianer(
                value: Gender.male,
                groupsValue: gender,
                title: 'Male',
                image: 'assets/images/male.png',
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: kContentSpacing8),
            Expanded(
              child: GenderContianer(
                value: Gender.female,
                groupsValue: gender,
                title: 'Female',
                image: 'assets/images/female.png',
                onChanged: (value) {},
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
        // final gender = signUpNotifier.selectedGender;
        return CustomElevatedButton(
          height: kButtonHeight,
          width: double.infinity,
          backgroundColor: kBlue,
          child: Text(
            'Continue',
            style: kFontBody.copyWith(color: kGrey),
          ),
          onPressed: onSubmit,
        );
      },
    );
  }
}
