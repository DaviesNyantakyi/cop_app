import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/page_navigation.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/gender_button.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Future<void> onSubmit() async {
    try {
      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (hasConnection) {
        nextPage(controller: widget.pageController);
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());

      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    }
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
        String question;
        String? displayName;

        if (signUpNotifier.displayName != null) {
          question = 'What\'s your gender,';
          displayName =
              '${signUpNotifier.displayName?.trim() ?? signUpNotifier.firstNameCntlr.text.trim()}?';
        } else {
          question = 'What\'s your date of birth?';
          displayName = '';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              displayName,
              style: Theme.of(context).textTheme.headline5,
            )
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
                groupsValue: signUpNotifier.selectedGender,
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
                groupsValue: signUpNotifier.selectedGender,
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
        final gender = signUpNotifier.selectedGender;
        return CustomElevatedButton(
          height: kButtonHeight,
          width: double.infinity,
          backgroundColor: gender != null ? kBlue : kGreyLight,
          child: Text(
            'Continue',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: gender != null ? kWhite : kGrey),
          ),
          onPressed: gender != null ? onSubmit : null,
        );
      },
    );
  }
}
