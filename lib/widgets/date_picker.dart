import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showCustomDatePicker({
  required CupertinoDatePickerMode mode,
  required DateTime initialDateTime,
  required BuildContext context,
  required Function(DateTime) onChanged,
  bool isDismissible = false,
  DateTime? maxDate,
}) async {
  FocusScope.of(context).requestFocus(FocusNode());

  showCustomBottomSheet(
    isDismissible: isDismissible,
    context: context,
    child: IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              child: CupertinoDatePicker(
                mode: mode,
                initialDateTime: initialDateTime,
                maximumDate: maxDate ?? kMaxDate,
                maximumYear: maxDate?.year ?? kMaxDate.year,
                minimumDate: kMinDate,
                minimumYear: kMinDate.year,
                dateOrder: DatePickerDateOrder.mdy,
                onDateTimeChanged: onChanged,
                use24hFormat: true,
              ),
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              backgroundColor: kBlue,
              child: Text('Done',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: kWhite)),
              height: kButtonHeight,
              width: double.infinity,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ),
  );
}
