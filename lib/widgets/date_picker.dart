import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';

Future<void> showCustomDatePicker({
  required CupertinoDatePickerMode mode,
  required DateTime initialDateTime,
  required BuildContext context,
  required Function(DateTime) onChanged,
  bool? isDismissible = false,
  DateTime? maxDate,
}) async {
  FocusScope.of(context).requestFocus(FocusNode());

  showCustomBottomSheet(
    isDismissable: false,
    context: context,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: mode,
              initialDateTime: initialDateTime,
              maximumDate: maxDate ?? kMaxDate,
              maximumYear: maxDate?.year ?? kMaxDate.year,
              minimumDate: kMinDate,
              minimumYear: kMinDate.year,
              onDateTimeChanged: onChanged,
              use24hFormat: true,
            ),
          ),
          CustomElevatedButton(
            backgroundColor: kBlue,
            child: Text('Done', style: kFontBody.copyWith(color: kWhite)),
            height: kButtonHeight,
            width: double.infinity,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}
