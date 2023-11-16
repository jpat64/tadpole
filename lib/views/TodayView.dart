// ignore_for_file: file_names, unnecessary_string_escapes

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool inPain = false;
  int painLevel = 0;
  bool flowing = false;
  int flowLevel = 0;
  Decimal? temperature;
  String? notes;

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
      bleeding = todayEntry?.bleeding ?? bleeding;
      selectedSymptoms = todayEntry?.symptoms ?? selectedSymptoms;
      selectedActivities = todayEntry?.activities ?? selectedActivities;
      todayId = t;
      inPain = ((todayEntry?.pain ?? painLevel) > 0);
      painLevel = inPain ? todayEntry?.pain ?? painLevel : 0;
      flowing = ((todayEntry?.flow ?? flowLevel) > 0);
      flowLevel = flowing ? todayEntry?.flow ?? flowLevel : 0;
      temperature = temperature ?? todayEntry?.temperature;
      notes = notes ?? todayEntry?.notes;
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
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
          ),
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
                Column(
                  children: [
                    Row(
                      children: [
                        Text(selectedTheme.painQuestion),
                        const Spacer(),
                        Checkbox(
                          value: inPain,
                          onChanged: (value) {
                            setState(() {
                              inPain = value ?? inPain;
                              painLevel = inPain ? 1 : 0;
                            });
                          },
                        ),
                      ],
                    ),
                    if (inPain)
                      Slider(
                        value: painLevel.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            painLevel = value.toInt();
                          });
                        },
                        min: 1,
                        max: 5,
                        divisions: 5,
                        label: painLevel.toString(),
                      ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(selectedTheme.flowQuestion),
                        const Spacer(),
                        Checkbox(
                          value: flowing,
                          onChanged: (value) {
                            setState(() {
                              flowing = value ?? flowing;
                              flowLevel = flowing ? 1 : 0;
                            });
                          },
                        ),
                      ],
                    ),
                    if (flowing)
                      Slider(
                        value: flowLevel.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            flowLevel = value.toInt();
                          });
                        },
                        min: 1.0,
                        max: 5.0,
                        divisions: 5,
                        label: flowLevel.toString(),
                      ),
                  ],
                ),
                Row(children: [
                  Text(selectedTheme.temperatureQuestion),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('^[0-9]*\.[0-9]*\$'))
                      ],
                      onChanged: (value) {
                        Decimal? decTemp = Decimal.tryParse(value);
                        setState(
                          () {
                            if (decTemp != null) {
                              temperature = decTemp;
                            }
                            if (value.isEmpty) {
                              temperature = null;
                            }
                          },
                        );
                      },
                    ),
                  ),
                ]),
                ExpansionTile(
                    initiallyExpanded: selectedSymptoms.isNotEmpty,
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
                    initiallyExpanded: selectedActivities.isNotEmpty,
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
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Enter your notes here...",
                  ),
                  minLines: 4,
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() {
                      notes = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool success = await controller.addEntry(
                        bleeding,
                        painLevel,
                        flowLevel,
                        selectedSymptoms,
                        selectedActivities);
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
          ),
        ),
      ),
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
