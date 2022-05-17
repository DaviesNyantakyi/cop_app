import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? initialValue;

  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final int? maxLines;
  final Function(String)? onSubmitted;
  final Color? fillColor;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;

  const CustomTextFormField({
    Key? key,
    this.hintText,
    this.initialValue,
    this.maxLines,
    this.keyboardType,
    this.controller,
    this.onSubmitted,
    this.style,
    this.onTap,
    this.border,
    this.focusedBorder,
    this.fillColor,
    this.prefixIcon,
    this.onChanged,
    this.hintStyle,
    this.validator,
    this.textInputAction,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      initialValue: initialValue,
      readOnly: readOnly,
      style: style ?? kFontBody,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      textInputAction: textInputAction,
      maxLines: maxLines,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        filled: true,
        errorMaxLines: 2,
        hintText: hintText,
        hintStyle: hintStyle ?? kFontBody.copyWith(color: kGrey),
        fillColor: fillColor ?? kWhite,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: kBoderWidth,
              ),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  width: kBoderWidth, color: readOnly ? kGrey : kBlue),
            ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
    );
  }
}
