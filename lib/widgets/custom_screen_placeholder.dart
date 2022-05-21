import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class CustomScreenPlaceholder extends StatelessWidget {
  const CustomScreenPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Text(
          'Share your testimony',
          style: kFontH6,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
