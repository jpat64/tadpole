// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/helpers/LocalStorageState.dart';

class ForecastView extends StatefulWidget {
  const ForecastView({super.key});

  @override
  State createState() => _ForecastViewState();
}

class _ForecastViewState extends LocalStorageState<ForecastView> {
  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forecast View"),
      ),
      body: Container(),
    );
  }
}
