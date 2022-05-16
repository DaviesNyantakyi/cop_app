import 'package:flutter/material.dart';

class CopLogo extends StatelessWidget {
  final double? width;
  final double? height;
  const CopLogo({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/cop_logo.png',
      width: width,
      height: height,
    );
  }
}
