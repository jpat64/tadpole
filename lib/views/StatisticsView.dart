// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/services/LocalStorageState.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State createState() => _StatisticsViewState();
}

class _StatisticsViewState extends LocalStorageState<StatisticsView> {
  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics View"),
      ),
      body: Container(),
    );
  }
}
