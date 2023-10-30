// ignore_for_file: file_names

import 'package:flutter/material.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics View"),
      ),
      body: Container(),
    );
  }
}
