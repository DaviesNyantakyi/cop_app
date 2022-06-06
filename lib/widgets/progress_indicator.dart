import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color color;
  final double size;
  const CustomCircularProgressIndicator({
    Key? key,
    this.color = kBlue,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 4,
        color: color,
      ),
    );
  }
}
