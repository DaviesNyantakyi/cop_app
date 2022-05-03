import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/date_picker.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerView extends StatefulWidget {
  const DatePickerView({Key? key}) : super(key: key);

  @override
  State<DatePickerView> createState() => _DatePickerViewState();
}

class _DatePickerViewState extends State<DatePickerView> {
  // The selected date of birth.
  DateTime selectedDate = DateTime.now();

  // The text shown when no date is selected.
  String? errorText;

  // If the chosen date is valid or not.
  bool validForm = false;

  Future<void> submit() async {
    bool hasConnection = await ConnectionChecker().checkConnection();

    if (hasConnection) {
      errorText = Validators.birthdayValidator(date: selectedDate);
    } else {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: ConnectionChecker.connectionException.message ?? '',
      );
    }
    setState(() {});
  }

  void validateDate() {
    DateTime today = DateTime.now();

    errorText = Validators.birthdayValidator(
      date: selectedDate,
    );

    // The form is valid if there is no error text and
    // if the selectedDate's year is smaller then current year.
    if (errorText == null && selectedDate.year < today.year) {
      validForm = true;
    } else {
      validForm = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
    );
  }

  Column _headerText() {
    final headerStyle = kFontH5.copyWith(fontWeight: FontWeight.normal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your date of birth,',
          style: headerStyle,
        ),
        Text(
          'Eva Smith?',
          style: headerStyle,
        ),
      ],
    );
  }

  Column _datePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomElevatedButton(
          side: BorderSide(color: validForm ? kBlue : kGrey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kContentSpacing8),
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
                      FormalDates.formatDmyyyy(date: selectedDate),
                      style: kFontBody,
                    ),
                  ],
                ),
              ],
            ),
          ),
          onPressed: () async {
            await showCustomDatePicker(
              initialDateTime: selectedDate,
              maxDate: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              context: context,
              onChanged: (date) {
                selectedDate = date;
                validateDate();
                setState(() {});
              },
            );
          },
        ),
        Validators().showValidationWidget(errorText: errorText)
      ],
    );
  }

  CustomElevatedButton _continueButton() {
    return CustomElevatedButton(
      width: double.infinity,
      backgroundColor: validForm ? kBlue : kGreyLight,
      child: Text(
        'Continue',
        style: kFontBody.copyWith(color: validForm ? kWhite : kGrey),
      ),
      onPressed: validForm ? submit : null,
    );
  }
}
