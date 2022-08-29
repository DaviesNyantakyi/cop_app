import 'package:flutter/material.dart';

import 'package:marquee/marquee.dart';

class CustomMarquee extends StatelessWidget {
  final String text;

  final TextStyle? style;
  const CustomMarquee({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Marquee(
      text: text,
      style: style,
      blankSpace: 8,
      velocity: 20,
      accelerationDuration: const Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: const Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
      pauseAfterRound: const Duration(seconds: 2),
    );
  }
}
