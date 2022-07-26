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
          textStyle: MaterialStateProperty.all<TextStyle?>(
            Theme.of(context).textTheme.bodyText1,
          ),
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
  final BorderSide? side;

  const CustomIconButton({
    Key? key,
    required this.leading,
    required this.label,
    required this.onPressed,
    this.height,
    this.width,
    this.radius = kRadius,
    this.backgroundColor = kBlue,
    this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomElevatedButton(
        side: side,
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
