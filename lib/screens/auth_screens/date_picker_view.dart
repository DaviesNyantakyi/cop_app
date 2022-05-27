import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
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
  late SignUpNotifier signUpNotifier;
  String? dateOfBirthErrorText;

  @override
  void initState() {
    signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);
    super.initState();
  }

  Future<void> onSubmit() async {
    try {
      signUpNotifier = Provider.of<SignUpNotifier>(context, listen: false);

      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (signUpNotifier.dateOfBirth?.year != null &&
          signUpNotifier.dateOfBirth!.year < currentDate.year) {
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
    if (signUpNotifier.dateOfBirth == null) {
      signUpNotifier.validateDateOfBirth(value: false);
    }

    if (signUpNotifier.dateOfBirth != null) {
      if (signUpNotifier.dateOfBirth!.year < currentDate.year) {
        signUpNotifier.validateDateOfBirth(value: true);
      } else {
        signUpNotifier.validateDateOfBirth(value: false);
      }
    }
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
    final headerStyle = kFontH5.copyWith(fontWeight: FontWeight.normal);

    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        String question;
        Widget? displayName;

        if (signUpNotifier.displayName != null) {
          question = 'What\'s your date of birth?';
          displayName = Text(
            '${signUpNotifier.displayName?.trim() ?? signUpNotifier.firstNameCntlr.text.trim()}?',
            style: kFontH5,
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
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomElevatedButton(
              height: kButtonHeight,
              side: BorderSide(
                color: signUpNotifier.dateOfBirth != null &&
                        signUpNotifier.dateOfBirthIsValid == true
                    ? kBlue
                    : kGrey,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kContentSpacing8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: kBlack,
                          size: kIconSize,
                        ),
                        const SizedBox(width: kContentSpacing8),
                        Text(
                          FormalDates.formatDmyyyy(
                                date: signUpNotifier.dateOfBirth,
                              ) ??
                              FormalDates.formatDmyyyy(date: DateTime.now()) ??
                              '',
                          style: kFontBody,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () async {
                await showCustomDatePicker(
                  initialDateTime: signUpNotifier.dateOfBirth ?? DateTime.now(),
                  maxDate: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  context: context,
                  onChanged: (date) {
                    signUpNotifier.setDateOfBirth(
                      value: date,
                    );
                    dateOfBirthErrorText = Validators.birthdayValidator(
                      date: date,
                    );
                    validDate();
                  },
                );
              },
            ),
            Validators().showValidationWidget(
              errorText: dateOfBirthErrorText,
            )
          ],
        );
      },
    );
  }

  Widget _continueButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          height: kButtonHeight,
          width: double.infinity,
          backgroundColor: signUpNotifier.dateOfBirth != null &&
                  signUpNotifier.dateOfBirthIsValid == true
              ? kBlue
              : kGreyLight,
          child: Text(
            'Continue',
            style: kFontBody.copyWith(
              color: signUpNotifier.dateOfBirth != null &&
                      signUpNotifier.dateOfBirthIsValid == true
                  ? kWhite
                  : kGrey,
            ),
          ),
          onPressed: signUpNotifier.dateOfBirth != null &&
                  signUpNotifier.dateOfBirthIsValid == true
              ? onSubmit
              : null,
        );
      },
    );
  }
}