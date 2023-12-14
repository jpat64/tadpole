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
  List<Symptom>? selectedSymptoms;
  List<Activity>? selectedActivities;

  // bleeding is in the form
  bool? bleeding;
  bool? newCycle;
  int? todayId;
  bool? inPain;
  int? painLevel;
  bool? flowing;
  int? flowLevel;
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
      bleeding = bleeding ?? todayEntry?.bleeding;
      newCycle = newCycle ?? false;
      selectedSymptoms = selectedSymptoms ?? todayEntry?.symptoms;
      selectedActivities = selectedActivities ?? todayEntry?.activities;
      todayId = todayId ?? t;
      inPain =
          inPain ?? (todayEntry?.pain != null ? todayEntry!.pain! > 0 : null);
      painLevel = painLevel ?? todayEntry?.pain;
      flowing =
          flowing ?? (todayEntry?.flow != null ? todayEntry!.flow! > 0 : null);
      flowLevel = flowLevel ?? todayEntry?.flow;
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
                        value: bleeding ?? false,
                        onChanged: (value) {
                          setState(() {
                            bleeding = value!;
                          });
                        })
                  ],
                ),
                Row(
                  children: [
                    Text(selectedTheme.newCycleQuestion),
                    const Spacer(),
                    Checkbox(
                        value: newCycle ?? false,
                        onChanged: (value) {
                          setState(() {
                            newCycle = value!;
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
                          value: inPain ?? false,
                          onChanged: (value) {
                            setState(() {
                              // checkbox value is always not null, since tristate is not true
                              inPain = value!;
                              painLevel = inPain! ? 1 : 0;
                            });
                          },
                        ),
                      ],
                    ),
                    if (inPain ?? false)
                      Slider(
                        value: painLevel?.toDouble() ?? 1,
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
                          value: flowing ?? false,
                          onChanged: (value) {
                            setState(() {
                              // checkbox value will always be non-null, since tristate is false
                              flowing = value!;
                              flowLevel = flowing! ? 1 : 0;
                            });
                          },
                        ),
                      ],
                    ),
                    if (flowing ?? false)
                      Slider(
                        value: flowLevel?.toDouble() ?? 1,
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
                    initiallyExpanded: selectedSymptoms?.isNotEmpty ?? false,
                    title: Text(selectedTheme.symptomQuestion),
                    children: symptoms.map<CheckboxListTile>((element) {
                      return CheckboxListTile(
                        value: selectedSymptoms?.contains(element) ?? false,
                        title: Text("${element.text} (${element.id})"),
                        onChanged: (value) {
                          List<Symptom> newSelectedSymptoms =
                              selectedSymptoms ??
                                  List<Symptom>.empty(growable: true);
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
                    initiallyExpanded: selectedActivities?.isNotEmpty ?? false,
                    title: Text(selectedTheme.activityQuestion),
                    children: activities.map<CheckboxListTile>((element) {
                      return CheckboxListTile(
                        value: selectedActivities?.contains(element) ?? false,
                        title: Text("${element.text} (${element.id})"),
                        onChanged: (value) {
                          List<Activity> newSelectedActivities =
                              selectedActivities ??
                                  List<Activity>.empty(growable: true);
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
                        bleeding ?? false,
                        newCycle ?? false,
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
                  "symptoms count: ${selectedSymptoms?.length ?? 'null'} / ${symptoms.length}",
                ),
                const Divider(height: 10),
                if (entries != null)
                  Column(
                    children: entries!.map<Text>((element) {
                      return Text(
                          "id: ${element.id} | cycle: ${element.cycle} | bleeding: ${element.bleeding} | Symptoms: ${element.symptoms?.length ?? 'null'}");
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
              Navigator.pushNamed(context, "/forecast");
            },
            child: const Text("Forecast"),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/history");
            },
            child: const Text("History"),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
            child: const Text("Settings"),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/statistics");
            },
            child: const Text("Statistics"),
          ),
        ],
      ),
    );
  }
}
