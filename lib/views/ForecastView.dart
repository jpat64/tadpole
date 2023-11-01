// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForecastView extends ConsumerStatefulWidget {
  const ForecastView({super.key});

  @override
  ConsumerState createState() => _ForecastViewState();
}

class _ForecastViewState extends ConsumerState<ForecastView> {
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
