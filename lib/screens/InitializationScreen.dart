// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/services/DatabaseService.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await setup();
      if (!mounted) return;
      context.goNamed("/calendar");
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Image.file(File("pixil-frame-0 (2).png")),
    );
  }
}
