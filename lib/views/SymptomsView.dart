// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/helpers/LocalStorageState.dart';

class SymptomsView extends StatefulWidget {
  const SymptomsView({super.key});

  @override
  State createState() => _SymptomsViewState();
}

class _SymptomsViewState extends LocalStorageState<SymptomsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptoms View"),
      ),
      body: Container(),
    );
  }
}
