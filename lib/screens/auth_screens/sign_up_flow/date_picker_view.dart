import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/utilities/methods.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/date_picker.dart';
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What\'s your date of birth,',
              style: headerStyle,
            ),
            Text(
              '${signUpNotifier.displayName ?? signUpNotifier.firstNameCntlr.text.trim()}?',
              style: kFontH5,
            ),
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
              side: BorderSide(
                color: signUpNotifier.dateOfBirthIsValid ? kBlue : kGrey,
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
                          ),
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
                    signUpNotifier.setDateOfBirth(value: date);
                    signUpNotifier.validateDate();
                  },
                );
              },
            ),
            Validators().showValidationWidget(
              errorText: signUpNotifier.errorText,
            )
          ],
        );
      },
    );
  }

  Widget _continueButton() {
    return Consumer<SignUpNotifier>(builder: (context, signUpNotifier, _) {
      final dateOfBirthIsValid = signUpNotifier.dateOfBirthIsValid;
      return CustomElevatedButton(
        width: double.infinity,
        backgroundColor: dateOfBirthIsValid ? kBlue : kGreyLight,
        child: Text(
          'Continue',
          style: kFontBody.copyWith(color: dateOfBirthIsValid ? kWhite : kGrey),
        ),
        onPressed: dateOfBirthIsValid ? onSubmit : null,
      );
    });
  }
}
