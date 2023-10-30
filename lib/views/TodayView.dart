// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today View"),
      ),
      body: Container(),
    );
  }
}
