import 'package:cop_belgium_app/models/testimony_model.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class TestimonyContent extends StatelessWidget {
  final TestimonyModel testimony;
  const TestimonyContent({
    Key? key,
    required this.testimony,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          testimony.title,
          maxLines: 1,
          style: kFontBody.copyWith(fontWeight: kFontWeightMedium),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: kContentSpacing4),
        Text(
          testimony.testimony,
          maxLines: 3,
          style: kFontBody,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
