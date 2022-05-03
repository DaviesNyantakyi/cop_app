import 'package:flutter/material.dart';

class CopLogo extends StatelessWidget {
  const CopLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/cop_logo.png',
      width: 100,
      height: 100,
    );
  }
}
