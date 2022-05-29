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
  final AlignmentGeometry? alignment;

  const CustomElevatedButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.height,
    this.width,
    this.side,
    this.padding,
    this.radius,
    this.backgroundColor,
    this.splashColor,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size?>(Size.zero),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(padding),
          textStyle: MaterialStateProperty.all<TextStyle?>(kFontBody),
          shape: MaterialStateProperty.all<OutlinedBorder?>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radius ?? kRadius),
              ),
            ),
          ),
          alignment: alignment,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

          backgroundColor: MaterialStateProperty.all<Color?>(
            backgroundColor ?? Colors.transparent,
          ),
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

class CustomIconButton extends StatelessWidget {
  final Widget leading;
  final Widget label;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final double? radius;
  final Color backgroundColor;

  const CustomIconButton({
    Key? key,
    required this.leading,
    required this.label,
    required this.onPressed,
    this.height,
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
            Align(alignment: Alignment.centerLeft, child: leading),
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

class SocialRatingButton extends StatelessWidget {
  final IconData leading;
  final String label;
  final VoidCallback? onPressed;

  const SocialRatingButton({
    Key? key,
    required this.leading,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      padding: EdgeInsets.zero,
      width: null,
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                leading,
                color: Colors.black,
                size: 18,
              ),
              const SizedBox(width: kContentSpacing4),
              Text(
                label,
                style: kFontBody2,
              )
            ],
          ),
          const SizedBox(width: kContentSpacing12),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
