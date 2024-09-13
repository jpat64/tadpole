// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/models/StyleTheme.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/screens/WelcomeSequenceScreen.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InitializationScreenState();

  static const String name = "/initialize";
  static const String path = "/";
}

class _InitializationScreenState extends State<InitializationScreen> {
  Future<String> setup() async {
    await DatabaseService.initialize();

    // only needs to run once
    DatabaseService instance = DatabaseService.instance;
    if (instance.getTheme('basic') == null) {
      DatabaseService.instance
          .addTheme(StyleTheme(paletteName: 'basic', unlocked: true));
    }
    if (instance.getTheme('secret') == null) {
      DatabaseService.instance
          .addTheme(StyleTheme(paletteName: 'secret', unlocked: false));
    }
    if (instance.getTheme('froggy') == null) {
      DatabaseService.instance
          .addTheme(StyleTheme(paletteName: 'froggy', unlocked: false));
    }
    late bool firstTime;
    try {
      firstTime = await SharedPreferencesService.firstTimeFlag;
    } catch (e) {
      firstTime = true;
      await SharedPreferencesService.setFirstTimeFlag(true);
    }
    Logger.info("Startup firstTime is $firstTime");

    late String selectedThemeName;
    try {
      selectedThemeName = await SharedPreferencesService.selectedThemeName;
    } catch (e) {
      selectedThemeName = "basic";
      await SharedPreferencesService.setSelectedThemeName("basic");
    }
    Logger.info("Startup selectedThemeName is $selectedThemeName");
    if (firstTime) {
      return WelcomeSequenceScreen.name;
    } else {
      return CalendarScreen.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      String destination = await setup();
      if (!context.mounted) return;
      switch (destination) {
        case CalendarScreen.name:
          context.pushNamed(destination, pathParameters: {
            "epochDate":
                "${DateTimeUtils.epochDays(DateUtils.addDaysToDate(DateTime.now(), 0))}"
          });
        default:
          context.goNamed(destination);
      }
    });

    return Scaffold(
      backgroundColor: Palette.basic.background,
      body: LayoutBuilder(
        builder: (context, constraints) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/app icon/app icon large.png",
                height: constraints.biggest.height * 0.8,
                width: constraints.biggest.width * 0.8),
          ],
        ),
      ),
    );
  }
}
