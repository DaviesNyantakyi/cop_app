import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/page_navigation.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/date_picker.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utilities/formal_dates.dart';

class DatePickerView extends StatefulWidget {
  final PageController pageController;

  const DatePickerView({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<DatePickerView> createState() => _DatePickerViewState();
}

class _DatePickerViewState extends State<DatePickerView> {
  final currentDate = DateTime.now();
  late SignUpProvider signUpProvider;
  String? dateOfBirthErrorText;

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    super.initState();
  }

  Future<void> onSubmit() async {
    try {
      signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (signUpProvider.dateOfBirth?.year != null &&
          signUpProvider.dateOfBirth!.year < currentDate.year) {
        if (hasConnection) {
          nextPage(controller: widget.pageController);
        } else {
          throw ConnectionNotifier.connectionException;
        }
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

  void validDate() {
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
        validDate();
      },
    );
    validDate();
    dateOfBirthErrorText = Validators.birthdayValidator(
      date: signUpProvider.dateOfBirth,
    );
    setState(() {});
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
                _datePicker(),
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
    final headerStyle = Theme.of(context).textTheme.headline5;

    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        String question;
        Widget? displayName;

        if (signUpProvider.displayName != null) {
          question = 'What\'s your date of birth,';
          displayName = Text(
            '${signUpProvider.displayName?.trim() ?? signUpProvider.firstNameCntlr.text.trim()}?',
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
      },
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

  Widget _continueButton() {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) {
        return CustomElevatedButton(
          height: kButtonHeight,
          width: double.infinity,
          backgroundColor: signUpProvider.dateOfBirth != null &&
                  signUpProvider.dateOfBirthIsValid == true
              ? kBlue
              : kGreyLight,
          child: Text(
            'Continue',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: signUpProvider.dateOfBirth != null &&
                          signUpProvider.dateOfBirthIsValid == true
                      ? kWhite
                      : kGrey,
                ),
          ),
          onPressed: signUpProvider.dateOfBirth != null &&
                  signUpProvider.dateOfBirthIsValid == true
              ? onSubmit
              : null,
        );
      },
    );
  }
}
