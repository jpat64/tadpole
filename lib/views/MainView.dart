// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/services/LocalStorageState.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State createState() => _MainViewState();
}

class _MainViewState extends LocalStorageState<MainView> {
  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tadpole"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Column(
          children: [
            Text("USE THIS FOR SANDBOX TESTING"),
          ],
        ),
      ),
    );
  }
}
