import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderSide? side;
  final double? radius;
  final Color? backgroundColor;

  const CustomElevatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.height,
    this.width,
    this.side,
    this.padding,
    this.radius,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? kButtonHeight,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.all(kContentSpacing8),
          primary: backgroundColor ?? kWhite,
          textStyle: kFontBody,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? kRadius),
            ),
          ),
          side: side,
          shadowColor: Colors.transparent,

          onPrimary: Colors.grey.shade500, // Splash color
        ),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? radius;
  final Color backgroundColor;

  const SocialButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.height = kButtonHeight,
    this.width,
    this.radius = kRadius,
    this.backgroundColor = kBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomElevatedButton(
        backgroundColor: backgroundColor,
        child: Stack(
          children: <Widget>[
            Align(alignment: Alignment.centerLeft, child: icon),
            Align(
              alignment: Alignment.center,
              child: label,
            )
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
