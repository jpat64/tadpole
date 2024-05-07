// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:moonbase/routes/router.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:moonbase/utils/ThemeSwitcher.dart';
import 'package:moonbase/utils/ThemeUtils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeData themeData = ThemeUtils.fromColorScheme(Palette.lightScheme);

  runApp(
    ThemeSwitcherWidget(
      initialTheme: themeData,
      child: Moonbase(themeData: themeData),
    ),
  );
}

class Moonbase extends StatelessWidget {
  ThemeData themeData;
  Moonbase({super.key, required this.themeData});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: themeData,
      routerConfig: router,
    );
  }
}
