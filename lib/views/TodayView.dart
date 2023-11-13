// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/TodayController.dart';
import 'package:tadpole/helpers/SelectableOrEntryRow.dart';
import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/models/ThemeModel.dart';
import 'package:tadpole/helpers/LocalStorageState.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State createState() => _TodayViewState();
}

class _TodayViewState extends LocalStorageState<TodayView> {
  final GlobalKey<FormState> _key = GlobalKey();

  TodayController controller = TodayController();
  ThemeModel selectedTheme = ThemeModel.base();
  List<Symptom> symptoms = List<Symptom>.empty(growable: true);
  List<Activity> activities = List<Activity>.empty(growable: true);

  // bleeding is in the form
  bool bleeding = false;

  List<Entry>? entries;

  @override
  Future<void> loadLocalData() async {
    PreferencesModel prefs = await controller.getPreferences();
    ThemeModel theme = await controller.getTheme(prefs.themeId);
    List<Symptom> s = await controller.getSymptoms();
    List<Activity> a = await controller.getActivities();
    setState(() {
      selectedTheme = theme;
      symptoms = s;
      activities = a;
    });
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    List<ListTile> symptomsList = symptoms.map<ListTile>((element) {
      return selectableOrEntryRow(
          listItem: element, checked: false, editable: false);
    }).toList();

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
                Text("Welcome to Today!! theme: ${selectedTheme.id}"),
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
                ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(selectedTheme.symptomQuestion),
                    children: symptomsList),
                ElevatedButton(
                  onPressed: () async {
                    bool success = await controller.addEntry(bleeding);
                    if (success) {
                      List<Entry> foundEntries = await controller.getEntries();
                      entries = foundEntries;
                    }
                  },
                  child: const Text("Submit"),
                ),
                const Divider(height: 10),
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
