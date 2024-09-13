// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MoonbaseTheme {
  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
      style: TextButton.styleFrom(textStyle: withFontSize(20)));

  static OutlinedButtonThemeData outlineButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(textStyle: withFontSize(20)));

  static TextTheme textTheme = TextTheme(
    displayLarge: textStyle,
    displayMedium: textStyle,
    displaySmall: textStyle,
    bodyMedium: textStyle,
    bodySmall: textStyle,
    bodyLarge: textStyle,
    titleLarge: withFontSize(26),
    titleMedium: textStyle,
    titleSmall: textStyle,
  );

  static const TextStyle textStyle = TextStyle(fontFamily: "Freeman");

  static TextStyle withFontSize(double fontSize) {
    return TextStyle(fontFamily: "Freeman", fontSize: fontSize);
  }
}
