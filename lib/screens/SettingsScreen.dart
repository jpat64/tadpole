// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/components/MoonbaseDateTimeSelector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();

  static const String name = "/settings";
  static const int navIndex = 2;
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DateTime relevantDateTime;

  @override
  void initState() {
    super.initState();
    relevantDateTime =
        DateTime.now(); // used for starting values for date time picker
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Settings", style: TextStyle(fontFamily: "Freeman")),
              ],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Go to Month:"),
            ),
            MoonbaseDateTimeSelector(
              year: relevantDateTime.year,
              month: relevantDateTime.month,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Go to Date:"),
            ),
            MoonbaseDateTimeSelector(
              year: relevantDateTime.year,
              month: relevantDateTime.month,
              day: relevantDateTime.day,
            ),
          ]),
        ),
        bottomNavigationBar:
            const MoonbaseBottomBar(selectedIndex: SettingsScreen.navIndex),
      ),
    );
  }
}
