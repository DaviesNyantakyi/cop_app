import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class GenderContianer extends StatelessWidget {
  final String title;
  final String image;
  final dynamic value;
  final dynamic groupsValue;
  final void Function(dynamic)? onChanged;
  const GenderContianer({
    Key? key,
    required this.value,
    required this.groupsValue,
    required this.title,
    required this.image,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.all(
          Radius.circular(kRadius),
        ),
        border: Border.all(
          width: kBoderWidth,
          color: groupsValue == value ? kBlue : kGrey,
        ),
      ),
      child: CustomElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(kContentSpacing8),
          child: Column(
            children: [
              Expanded(child: Image.asset(image)),
              const SizedBox(height: kContentSpacing4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        onPressed: () {
          onChanged!(value);
        },
      ),
    );
  }
}
