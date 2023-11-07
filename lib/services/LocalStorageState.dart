// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/views/LoadingScreen.dart';

abstract class LocalStorageState<T extends StatefulWidget> extends State<T> {
  Future<void> loadLocalData() async {}

  bool isDataLoaded() => true;

  Widget buildAfterLoad(BuildContext context) {
    return const Scaffold(
      body: Text("LocalStorageState :: must be overridden"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadLocalData(),
      builder: (context, snapshot) {
        if (!isDataLoaded()) {
          return loadingScreen();
        } else {
          return buildAfterLoad(context);
        }
      },
    );
  }
}
