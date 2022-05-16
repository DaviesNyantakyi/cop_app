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
  final Color? splashColor;

  const CustomElevatedButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.height = kButtonHeight,
    this.width,
    this.side,
    this.padding,
    this.radius,
    this.backgroundColor,
    this.splashColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(padding),
          textStyle: MaterialStateProperty.all<TextStyle?>(kFontBody),
          shape: MaterialStateProperty.all<OutlinedBorder?>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radius ?? kRadius),
              ),
            ),
          ),
          backgroundColor:
              MaterialStateProperty.all<Color?>(backgroundColor ?? kWhite),
          side: MaterialStateProperty.all<BorderSide?>(side),
          shadowColor: MaterialStateProperty.all<Color?>(Colors.transparent),
          elevation: MaterialStateProperty.all<double?>(0.0),

          //Splash color
          overlayColor: MaterialStateProperty.all<Color?>(
            splashColor ?? kGrey.withOpacity(0.2),
          ),
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
