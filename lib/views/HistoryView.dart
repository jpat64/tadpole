// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/services/LocalStorageState.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State createState() => _HistoryViewState();
}

class _HistoryViewState extends LocalStorageState<HistoryView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History View"),
      ),
      body: Container(),
    );
  }
}
