// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InitializationScreenState();

  static const String name = "/initialize";
  static const String path = "/";
}

class _InitializationScreenState extends State<InitializationScreen> {
  Future<void> setup() async {
    await DatabaseService.initialize();

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
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await setup();
      if (!context.mounted) return;
      context.pushNamed(CalendarScreen.name, pathParameters: {
        "epochDate":
            "${DateTimeUtils.epochDays(DateUtils.addDaysToDate(DateTime.now(), 0))}"
      });
    });

    return Scaffold(
        appBar: AppBar(title: const Text("(M) Moonbase")),
        body: LayoutBuilder(
            builder: (context, constraints) =>
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset("assets/images/app icon/app icon large.png",
                      height: constraints.biggest.height * 0.8,
                      width: constraints.biggest.width * 0.8),
                ])));
  }
}
