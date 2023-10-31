// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/SettingsController.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsController controller = SettingsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings View"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await controller.clearEntries();
              },
              child: const Text("reset Entries"),
            ),
          ],
        ),
      ),
    );
  }
}
