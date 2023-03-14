import 'package:flutter/material.dart';
import 'package:to_do_app/constants/app_colors.dart';

TextStyle getStyle(
        {FontWeight? fontWeight,
        double? fontSize,
        Color? color = AppColors.nightRiderColor,
        double? height,
        TextDecoration? decoration = TextDecoration.none,
        double? letterSpacing}) =>
    TextStyle(
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontSize: fontSize ?? 18,
        height: height,
        color: color,
        decoration: decoration);
