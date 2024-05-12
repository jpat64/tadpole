// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    //DatabaseService instance = DatabaseService.instance();
    //var success = await instance.addTags(["hungry", "thirsty", "sad"]);
    //print('startup: $success ${instance.searchTags("thirs")}');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await setup();
      if (!context.mounted) return;
      context.pushNamed(CalendarScreen.name, pathParameters: {
        "epochDate": "${DateTimeUtils.epochDays(DateTime.now())}"
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Image.asset("assets/images/logo/light-logo.png"),
    );
  }
}
