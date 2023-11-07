// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/SettingsController.dart';
import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/models/ThemeModel.dart';
import 'package:tadpole/services/LocalStorageState.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State createState() => _SettingsViewState();
}

class _SettingsViewState extends LocalStorageState<SettingsView> {
  SettingsController controller = SettingsController();

  Map<int, ThemeModel> availableThemes = Map<int, ThemeModel>.from({});
  PreferencesModel? prefs;

  @override
  Future<void> loadLocalData() async {
    availableThemes = await controller.getAvailableThemes();
    prefs = await controller.getPreferences();
  }

  @override
  bool isDataLoaded() {
    return availableThemes.isNotEmpty && prefs != null;
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
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
            ElevatedButton(
              onPressed: () async {
                await controller.clearPreferences();
              },
              child: const Text("reset Preferences"),
            ),
            DropdownButton<int>(
              value: prefs!.themeId,
              onChanged: (value) async {
                setState(() {
                  // updates the display in the dropdownmenu
                  prefs!.themeId = value!;
                });
                await controller.updatePreferences(prefs!);
              },
              items:
                  availableThemes.values.map<DropdownMenuItem<int>>((element) {
                return DropdownMenuItem<int>(
                  value: element.id,
                  child: Text("id: ${element.id}"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
