import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomErrorWidget({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kContentSpacing16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Something went wrong,',
                style: kFontH6,
              ),
              const Text(
                'please try again.',
                style: kFontH6,
              ),
              const SizedBox(height: kContentSpacing24),
              CustomElevatedButton(
                width: double.infinity,
                backgroundColor: kBlue,
                child: Text(
                  'Try again',
                  style: kFontBody.copyWith(color: kWhite),
                ),
                onPressed: onPressed,
              )
            ],
          ),
        ),
      ),
    );
  }
}
