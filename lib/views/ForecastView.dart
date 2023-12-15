// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/ForecastController.dart';
import 'package:tadpole/helpers/LocalStorageState.dart';
import 'package:tadpole/models/EntryModel.dart';

class ForecastView extends StatefulWidget {
  const ForecastView({super.key});

  @override
  State createState() => _ForecastViewState();
}

class _ForecastViewState extends LocalStorageState<ForecastView> {
  bool initialLoad = true;

  ForecastController controller = ForecastController();

  List<Entry>? entriesFromThisCycle;

  @override
  Future<void> loadLocalData() async {
    if (initialLoad) {
      initialLoad = false;

      entriesFromThisCycle = await controller.entriesFromThisCycle();
    }
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forecast View"),
      ),
      body: Container(
          child: Text(
              "number of entries in this cycle: ${entriesFromThisCycle?.length ?? 'null'}")),
    );
  }
}
