// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/screens/EntryScreen.dart';
import 'package:moonbase/screens/SettingsScreen.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseBottomBar extends StatelessWidget {
  final Palette palette;
  final int selectedIndex;

  const MoonbaseBottomBar(
      {super.key, required this.palette, required this.selectedIndex});

  static const Map<String, NavigationDestination> navBarItems = {
    CalendarScreen.name: NavigationDestination(
      icon: Icon(Icons.calendar_month),
      label: "Calendar",
    ),
    EntryScreen.name: NavigationDestination(
      icon: Icon(Icons.calendar_today),
      label: "Today",
    ),
    SettingsScreen.name: NavigationDestination(
      icon: Icon(Icons.settings),
      label: "Settings",
    ),
  };

  static Map<String, String> defaultParameters(String path) {
    switch (path) {
      case CalendarScreen.name:
        return {"epochDate": "${CalendarScreen.defaultEpochDate}"};
      case EntryScreen.name:
        return {"epochDate": "${EntryScreen.defaultEpochDate}"};
      default:
        return const <String, String>{};
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        destinations: navBarItems.values.toList(),
        selectedIndex: selectedIndex,
        surfaceTintColor: palette.background,
        indicatorColor: palette.splash,
        onDestinationSelected: (value) {
          String path = navBarItems.keys.toList()[value];
          Map<String, String> parameters = defaultParameters(path);
          context.pushNamed(navBarItems.keys.toList()[value],
              pathParameters: parameters);
        });
  }
}
