// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Palette {
  static ColorScheme lightTheme = ColorScheme(
    brightness: Brightness.light,
    background: neutral[200]!,
    onBackground: black,
    primary: manila[300]!,
    onPrimary: black,
    secondary: info[300]!,
    onSecondary: black,
    surface: neutral[300]!,
    onSurface: black,
    error: error[400]!,
    onError: black,
    tertiary: warning[400]!,
    onTertiary: black,
  );

  static ColorScheme darkTheme = ColorScheme(
    brightness: Brightness.light,
    background: neutral[200]!,
    onBackground: black,
    primary: manila[300]!,
    onPrimary: black,
    secondary: info[300]!,
    onSecondary: black,
    surface: neutral[300]!,
    onSurface: black,
    error: error[400]!,
    onError: black,
    tertiary: warning[400]!,
    onTertiary: black,
  );

  static const MaterialColor manila = MaterialColor(0xffc99f38, {
    100: Color(0xfff5eed8),
    200: Color(0xfff5dea6),
    300: Color(0xfff0d38c),
    400: Color(0xffe1bb5e),
    500: Color(0xffc99f38),
    600: Color(0xffaf8521),
    700: Color(0xff816012),
    800: Color(0xff684c0a),
    900: Color(0xff463305),
  });

  static const MaterialColor error = MaterialColor(0xffc93c3c, {
    100: Color(0xfff5dfd8),
    200: Color(0xfff5b3a6),
    300: Color(0xfff9d38c),
    400: Color(0xffe1745e),
    500: Color(0xffc93c3c),
    600: Color(0xffaf3921),
    700: Color(0xff812512),
    800: Color(0xff681a0a),
    900: Color(0xff461005),
  });

  static const MaterialColor warning = MaterialColor(0xffc96b3c, {
    100: Color(0xfff5e4d8),
    200: Color(0xfff5c0a6),
    300: Color(0xfff0ad8c),
    400: Color(0xffe18a5e),
    500: Color(0xffc96b3c),
    600: Color(0xffaf5021),
    700: Color(0xff813712),
    800: Color(0xff68290a),
    900: Color(0xff461b05),
  });

  static const MaterialColor info = MaterialColor(0xff3c6bc9, {
    100: Color(0xffd8e4f5),
    200: Color(0xffa6c0f5),
    300: Color(0xff8cadf0),
    400: Color(0xff5e8ae1),
    600: Color(0xff2150af),
    700: Color(0xff123781),
    800: Color(0xff0a2968),
    900: Color(0xff051b46),
  });

  static const MaterialColor success = MaterialColor(0xff68c93c, {
    100: Color(0xffe4f5d8),
    200: Color(0xffc0f5a6),
    300: Color(0xffadf08c),
    400: Color(0xff8ae15e),
    500: Color(0xff68c93c),
    600: Color(0xff50af21),
    700: Color(0xff378112),
    800: Color(0xff29680a),
    900: Color(0xff1b4605),
  });

  static const MaterialColor neutral = MaterialColor(0xff616a9a, {
    100: Color(0xffd8d9e0),
    200: Color(0xffaeb2c9),
    300: Color(0xff9196b2),
    400: Color(0xff757ca3),
    500: Color(0xff616a9a),
    600: Color(0xff414a79),
    700: Color(0xff2e3559),
    800: Color(0xff212749),
    900: Color(0xff0e1124),
  });

  static const Color black = Colors.black;

  static const Color white = Colors.white;
}
