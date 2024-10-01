// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';

class Palette {
  Color background;
  Color text;
  Color primary;
  Color secondary;
  Color splash;
  Color accent;
  Color off;
  Color disabled;
  Color error;
  ColorScheme get lightTheme => ColorScheme(
        brightness: Brightness.light,
        surface: background,
        onSurface: text,
        background: text,
        onBackground: background,
        primary: primary,
        onPrimary: background,
        secondary: secondary,
        onSecondary: text,
        tertiary: accent,
        onTertiary: text,
        error: error,
        onError: text,
      );

  ColorScheme get darkTheme => ColorScheme(
        brightness: Brightness.dark,
        surface: text,
        onSurface: background,
        background: text,
        onBackground: background,
        primary: primary,
        onPrimary: text,
        secondary: secondary,
        onSecondary: background,
        tertiary: accent,
        onTertiary: background,
        error: error,
        onError: background,
      );

  Palette({
    required this.background,
    required this.text,
    required this.primary,
    required this.secondary,
    required this.splash,
    required this.accent,
    required this.off,
    required this.disabled,
    required this.error,
  });

  List<Color> get swatches => [primary, secondary, splash, accent, error];

  static Palette get basic => Palette(
        background: Colors.paperworkWhite,
        text: Colors.graphiteGray,
        primary: Colors.spaceBlue,
        secondary: Colors.troposphereBlue,
        splash: Colors.reflectiveHullPeach,
        accent: Colors.goopGreen,
        off: Colors.moonGray,
        disabled: Colors.craterGray,
        error: Colors.alertRed,
      );

  static Palette get froggy => Palette(
        background: Colors.seafoamWhite,
        text: Colors.pupilBlack,
        primary: Colors.froggyGreen,
        secondary: Colors.tealeafGreen,
        splash: Colors.salmonPink,
        accent: Colors.waterBlue,
        off: Colors.moonGray,
        disabled: Colors.craterGray,
        error: Colors.jasperRed,
      );

  static Palette get princess => Palette(
        background: Colors.royalPurple,
        text: Colors.leadershipBlack,
        primary: Colors.pompPurple,
        secondary: Colors.pridePurple,
        splash: Colors.jewelBlue,
        accent: Colors.crownGold,
        off: Colors.moonGray,
        disabled: Colors.craterGray,
        error: Colors.regalRed,
      );

  static Map<String, Palette> get palettesByName => {
        "basic": basic,
        "froggy": froggy,
        "princess": princess,
      };

  static Future<Palette> get currentPalette async {
    String currentThemeName = await SharedPreferencesService.selectedThemeName;
    if (palettesByName.keys.contains(currentThemeName)) {
      return palettesByName[currentThemeName]!;
    }
    Logger.warning("unable to find current palette $currentThemeName");
    return basic;
  }

  IconThemeData get iconTheme => IconThemeData(color: text);
  TextStyle get titleTextTheme => TextStyle(color: text, fontSize: 24);
}

class Colors {
  // basic palette colors
  static Color paperworkWhite = const Color(0xfffffdfa);
  static Color graphiteGray = const Color(0xff1a1a16);
  static Color spaceBlue = const Color(0xff1f1847);
  static Color troposphereBlue = const Color(0xffe0e8ff);
  static Color reflectiveHullPeach = const Color(0xfff7c5a1);
  static Color goopGreen = const Color(0xff4bb24b);
  static Color moonGray = const Color(0xffd9d5d0);
  static Color craterGray = const Color(0xffa1a19a);
  static Color alertRed = const Color(0xffd95553);

  // froggy palette colors
  static Color seafoamWhite = const Color(0xfffafffa);
  static Color pupilBlack = const Color(0xff141a12);
  static Color froggyGreen = const Color(0xff488046);
  static Color tealeafGreen = const Color(0xffc0dbbf);
  static Color salmonPink = const Color(0xfff4989c);
  static Color waterBlue = const Color(0xff6d96e3);
  static Color jasperRed = const Color(0xffde534b);

  // princess palette colors
  static Color royalPurple = const Color(0xfffcf7ff);
  static Color leadershipBlack = const Color(0xff1e1721);
  static Color pompPurple = const Color(0xff836096);
  static Color pridePurple = const Color(0xffe1caed);
  static Color regalRed = const Color(0xffe6456d);
  static Color crownGold = const Color(0xfff3c141);
  static Color jewelBlue = const Color(0xff87eded);
}
