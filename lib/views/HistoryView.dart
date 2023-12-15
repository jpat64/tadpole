// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/HistoryController.dart';
import 'package:tadpole/helpers/LocalStorageState.dart';
import 'package:tadpole/models/EntryModel.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State createState() => _HistoryViewState();
}

class _HistoryViewState extends LocalStorageState<HistoryView> {
  bool initialLoad = true;

  HistoryController controller = HistoryController();

  List<Entry>? entries;

  @override
  Future<void> loadLocalData() async {
    if (initialLoad) {
      initialLoad = false;
      entries = await controller.getEntries();
    }
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History View"),
      ),
      body: Container(
          child: Text("number of entries: ${entries?.length ?? 'null'}")),
    );
  }
}
