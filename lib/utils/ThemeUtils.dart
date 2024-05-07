// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ThemeUtils {
  static ButtonStyle dangerButtonStyle(ColorScheme scheme) =>
      TextButton.styleFrom(
          backgroundColor: scheme.error, foregroundColor: scheme.onError);

  static ButtonStyle successButtonStyle(ColorScheme scheme) =>
      TextButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary);

  static ThemeData fromColorScheme(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: scheme.background,
        filled: true,
        border: InputBorder.none,
        disabledBorder: InputBorder.none,
        helperStyle: TextStyle(fontSize: 10, color: scheme.onSurface),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(scheme.secondary),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurface,
        textColor: scheme.onSurface,
        selectedColor: scheme.secondary,
        subtitleTextStyle: TextStyle(color: scheme.onSurface),
        titleTextStyle: TextStyle(color: scheme.onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.secondary,
        labelTextStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(color: scheme.onSurface),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        titleTextStyle: TextStyle(color: scheme.onSurface, fontSize: 24),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          textStyle: TextStyle(color: scheme.onSurface),
          disabledBackgroundColor: scheme.surface,
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: 16, color: scheme.onSurface),
        bodySmall: TextStyle(fontSize: 10, color: scheme.onSurface),
      ),
    );
  }
}
