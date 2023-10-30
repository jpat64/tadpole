// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ForecastView extends StatefulWidget {
  const ForecastView({super.key});

  @override
  State createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forecast View"),
      ),
      body: Container(),
    );
  }
}
