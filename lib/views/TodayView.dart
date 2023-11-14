// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/TodayController.dart';
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
  List<Symptom> selectedSymptoms = List<Symptom>.empty(growable: true);
  List<Activity> selectedActivities = List<Activity>.empty(growable: true);

  // bleeding is in the form
  bool bleeding = false;
  int todayId = -1;

  List<Entry>? entries;

  @override
  Future<void> loadLocalData() async {
    PreferencesModel prefs = await controller.getPreferences();
    ThemeModel theme = await controller.getTheme(prefs.themeId);
    List<Symptom> s = await controller.getSymptoms();
    List<Activity> a = await controller.getActivities();
    List<Entry> e = await controller.getEntries();
    int t = controller.getTodayId();
    int entryExistsIndex = e.indexOf(Entry(id: t, bleeding: false, cycle: 0));
    Entry? todayEntry =
        entryExistsIndex >= 0 ? e.elementAt(entryExistsIndex) : null;
    setState(() {
      selectedTheme = theme;
      symptoms = s;
      activities = a;
      bleeding = todayEntry?.bleeding ?? false;
      selectedSymptoms =
          todayEntry?.symptoms ?? List<Symptom>.empty(growable: true);
      selectedActivities =
          todayEntry?.activities ?? List<Activity>.empty(growable: true);
      todayId = t;
    });
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
            child: ListView(
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
                    children: symptoms.map<CheckboxListTile>((element) {
                      return CheckboxListTile(
                        value: selectedSymptoms.contains(element),
                        title: Text("${element.text} (${element.id})"),
                        onChanged: (value) {
                          List<Symptom> newSelectedSymptoms = selectedSymptoms;
                          if (value == true) {
                            newSelectedSymptoms.add(element);
                          }
                          if (value == false) {
                            newSelectedSymptoms.remove(element);
                          }
                          setState(() {
                            selectedSymptoms = newSelectedSymptoms;
                          });
                        },
                      );
                    }).toList()),
                ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(selectedTheme.activityQuestion),
                    children: activities.map<CheckboxListTile>((element) {
                      return CheckboxListTile(
                        value: selectedActivities.contains(element),
                        title: Text("${element.text} (${element.id})"),
                        onChanged: (value) {
                          List<Activity> newSelectedActivities =
                              selectedActivities;
                          if (value == true) {
                            newSelectedActivities.add(element);
                          }
                          if (value == false) {
                            newSelectedActivities.remove(element);
                          }
                          setState(() {
                            selectedActivities = newSelectedActivities;
                          });
                        },
                      );
                    }).toList()),
                ElevatedButton(
                  onPressed: () async {
                    bool success =
                        await controller.addEntry(bleeding, selectedSymptoms);
                    if (success) {
                      // addEntry() takes a bit of time, so we were hitting getEntries() too quickly. Waiting zero makes sure we go in order.
                      await Future.delayed(Duration.zero);
                      List<Entry> foundEntries = await controller.getEntries();
                      setState(() {
                        entries = foundEntries;
                      });
                    }
                  },
                  child: const Text("Submit"),
                ),
                const Divider(height: 10),
                Text(
                  "symptoms count: ${selectedSymptoms.length} / ${symptoms.length}",
                ),
                const Divider(height: 10),
                if (entries != null)
                  Column(
                    children: entries!.map<Text>((element) {
                      return Text(
                          "${element.id} | ${element.bleeding} | Symptoms: ${element.symptoms?.length ?? 'null'}");
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
