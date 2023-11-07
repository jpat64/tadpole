// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/TodayController.dart';
import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/models/ThemeModel.dart';
import 'package:tadpole/services/LocalStorageState.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State createState() => _TodayViewState();
}

class _TodayViewState extends LocalStorageState<TodayView> {
  final GlobalKey<FormState> _key = GlobalKey();

  TodayController controller = TodayController();
  ThemeModel selectedTheme = ThemeModel.base();

  // bleeding is in the form
  bool bleeding = false;

  List<Entry>? entries;

  @override
  Future<void> loadLocalData() async {
    PreferencesModel prefs = await controller.getPreferences();
    selectedTheme = await controller.getTheme(prefs.themeId);
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today View"),
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _key,
            child: Column(
              children: [
                Text("Welcome to Tadpole! theme: ${selectedTheme.id}"),
                Row(
                  children: [
                    Text(selectedTheme.bleedingQuestion),
                    const Spacer(),
                    Checkbox(
                        value: bleeding,
                        onChanged: (value) {
                          setState(() {
                            bleeding = value ?? bleeding;
                          });
                        })
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    controller.addEntry(bleeding);
                  },
                  child: const Text("Submit"),
                ),
                const Divider(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    List<Entry> foundEntries = await controller.getEntries();
                    setState(() {
                      entries = foundEntries;
                    });
                  },
                  child: const Text("Refresh Entries"),
                ),
                if (entries != null)
                  Column(
                    children: entries!.map<Text>((element) {
                      return Text(
                          "${element.id} | ${element.date} | ${element.bleeding}");
                    }).toList(),
                  )
              ],
            ),
          )),
      bottomNavigationBar: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
            child: const Text("Settings"),
          )
        ],
      ),
    );
  }
}
