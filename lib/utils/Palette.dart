// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Palette {
  static ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    background: tan[50]!,
    onBackground: black,
    primary: tan[700]!,
    onPrimary: black,
    secondary: blue[300]!,
    onSecondary: black,
    surface: tan[50]!,
    onSurface: black,
    error: red[400]!,
    onError: black,
    tertiary: green[400]!,
    onTertiary: black,
    outline: black,
  );

  static ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.light,
    background: gray[900]!,
    onBackground: white,
    primary: tan[700]!,
    onPrimary: white,
    secondary: blue[700]!,
    onSecondary: white,
    surface: gray[800]!,
    onSurface: white,
    error: red[600]!,
    onError: white,
    tertiary: green[600]!,
    onTertiary: white,
    outline: white,
  );

  static const MaterialColor tan = MaterialColor(0xffe0bc5e, {
    50: Color(0xfffaf6ed),
    100: Color(0xfff9e9c1),
    200: Color(0xfff1ddaa),
    300: Color(0xfff2d487),
    400: Color(0xffe0bc5e),
    500: Color(0xffc9a13d),
    600: Color(0xffbd9223),
    700: Color(0xffa37a14),
    800: Color(0xff5f4504),
    900: Color(0xff0f0b00),
  });

  static const MaterialColor red = MaterialColor(0xffc14656, {
    50: Color(0xfffaf3f4),
    100: Color(0xfff6d5d9),
    200: Color(0xfff8a8b3),
    300: Color(0xffe26a7a),
    400: Color(0xffc14656),
    500: Color(0xffa43242),
    600: Color(0xff8e1323),
    700: Color(0xff75121f),
    800: Color(0xff561019),
    900: Color(0xff0e0102),
  });

  static const MaterialColor orange = MaterialColor(0xffc17948, {
    50: Color(0xfff1ebe6),
    100: Color(0xfff4d5bf),
    200: Color(0xffdbaf91),
    300: Color(0xffd29064),
    400: Color(0xffc17948),
    500: Color(0xffa95721),
    600: Color(0xff8B471a),
    700: Color(0xff6a340f),
    800: Color(0xff4a2105),
    900: Color(0xff210e01),
  });

  static const MaterialColor yellow = MaterialColor(0xffc1b74b, {
    50: Color(0xfff1f0e6),
    100: Color(0xfff4f0bf),
    200: Color(0xffdbd591),
    300: Color(0xffd2c964),
    400: Color(0xffc1b74b),
    500: Color(0xffecec21),
    600: Color(0xff8B821a),
    700: Color(0xff6a630f),
    800: Color(0xff4a4505),
    900: Color(0xff211e01),
  });

  static const MaterialColor green = MaterialColor(0xff56a43d, {
    50: Color(0xffeef8ea),
    100: Color(0xffcdf0c1),
    200: Color(0xffa3e28d),
    300: Color(0xff78cd5c),
    400: Color(0xff56a43d),
    500: Color(0xff379518),
    600: Color(0xff2a6b14),
    700: Color(0xff20550f),
    800: Color(0xff103405),
    900: Color(0xff092101),
  });

  static const MaterialColor blue = MaterialColor(0xff5e81e0, {
    50: Color(0xffeff3fd),
    100: Color(0xffc7d4f9),
    200: Color(0xffa1b4e8),
    300: Color(0xff7e9ae5),
    400: Color(0xff5e81e0),
    500: Color(0xff3f64c8),
    600: Color(0xff132d75),
    700: Color(0xff0c2364),
    800: Color(0xff041237),
    000: Color(0xff01040d),
  });

  static const MaterialColor purple = MaterialColor(0xffa75ee0, {
    50: Color(0xfff7effd),
    100: Color(0xffe3c7f9),
    200: Color(0xffc9a1e8),
    300: Color(0xffb97ee5),
    400: Color(0xffa75ee0),
    500: Color(0xff8d3fc8),
    600: Color(0xff4b1375),
    700: Color(0xff3e0c64),
    800: Color(0xff210437),
    900: Color(0xff07010d),
  });

  static const MaterialColor pink = MaterialColor(0xffe05ed3, {
    50: Color(0xfffdeffc),
    100: Color(0xfff9c7f4),
    200: Color(0xffe8a1e1),
    300: Color(0xffe57edb),
    400: Color(0xffe05ed3),
    500: Color(0xffc83fba),
    600: Color(0xff75136b),
    700: Color(0xff640c5b),
    800: Color(0xff370432),
    900: Color(0xff0d010c),
  });

  static const MaterialColor gray = MaterialColor(0xff595b5e, {
    50: Color(0xfffffffc),
    100: Color(0xffdddfe1),
    200: Color(0xffadafb2),
    300: Color(0xff939599),
    400: Color(0xff595b5e),
    500: Color(0xff2f353e),
    600: Color(0xff1f2631),
    700: Color(0xff151d29),
    800: Color(0xff040b15),
    900: Color(0xff000813),
  });

  static const Color black = Colors.black;

  static const Color white = Colors.white;
}
