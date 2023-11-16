// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/views/LoadingScreen.dart';

abstract class LocalStorageState<T extends StatefulWidget> extends State<T> {
  /// async method called as the <future> component of the local data FutureBuilder.
  /// implementation should have two parts:
  /// 1. load each of the pieces of data into local variables
  /// 2. setState() with the local variables, essentially cheating out an async setState()
  /// something cool I found out is that this also auto-updates with usage of the back button which is dope.
  Future<void> loadLocalData() async {}

  /// the condition of switching between a loading screen and whatever buildAfterLoad returns.
  /// Should be contingent on state variables, so use those as opposed to parameters.
  bool isDataLoaded() => true;

  /// basically, what build() would be if you didn't have to wait for async operations to happen.
  /// This is what has to be overwritten in order for this to work.
  Widget buildAfterLoad(BuildContext context) {
    return const Scaffold(
      body: Text("LocalStorageState :: must be overridden"),
    );
  }

  /// Probably don't override this, as it's the most integral part of this method.
  /// If you're overriding this, you should probably just use State<StatefulWidget>.
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
