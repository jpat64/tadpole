// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/services/DatabaseService.dart';
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
    // DEBUG MODE: ADD AN ENTRY FOR YESTERDAY
    DatabaseService instance = DatabaseService.instance();
    await instance.addDailyEntry(DailyEntry(
        isActive: true,
        notes: "Notey wotey",
        epochDate: DateTimeUtils.epochDays(
            DateUtils.addDaysToDate(DateTime.now(), -1))));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await setup();
      if (!context.mounted) return;
      context.goNamed(CalendarScreen.name, pathParameters: {
        "epochDate": "${DateTimeUtils.epochDays(DateTime.now())}"
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Image.file(File("pixil-frame-0 (2).png")),
    );
  }
}
