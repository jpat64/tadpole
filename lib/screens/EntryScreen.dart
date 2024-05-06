// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/components/LoadingWidget.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';

import 'package:intl/intl.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.epochDate});

  final int epochDate;

  @override
  State<StatefulWidget> createState() => _EntryScreenState();

  static const String name = "/entry";
  static const int navIndex = 1;
  static int defaultEpochDate = DateTimeUtils.epochDays(DateTime.now());
}

class _EntryScreenState extends State<EntryScreen> {
  DateTime? relevantDateTime;

  DateFormat dayMonthYear = DateFormat("MMMM dd yyyy");

  late bool isActive;
  late final int epochDate;
  TextEditingController notesTextController = TextEditingController();
  late String notes;

  bool editingMode = false;
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    relevantDateTime = DateTimeUtils.dateFromEpochDays(widget.epochDate);
    epochDate = DateTimeUtils.epochDays(relevantDateTime!);
  }

  void loadDailyEntry() {
    DatabaseService instance = DatabaseService.instance();
    bool isEntryActive = instance.isEntryActiveForDay(epochDate);
    DailyEntry? relevantEntry;
    if (isEntryActive) {
      relevantEntry = instance.getDailyEntry(epochDate);
    }
    setState(() {
      if (relevantEntry == null) {
        editingMode = true;
        isActive = false;
        notes = "";
        notesTextController.text = "";
      } else {
        isActive = relevantEntry.isActive;
        notes = relevantEntry.notes ?? "";
        notesTextController.text = notes;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      // only run if not loaded
      if (loaded == false) {
        loadDailyEntry();
        setState(() {
          loaded = true;
        });
      }
    });

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayMonthYear.format(relevantDateTime!),
                ),
                IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        editingMode = !editingMode;
                      });
                    })
              ],
            ),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: loaded
                ? Column(children: [
                    Card(
                      child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            // the form
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: CheckboxListTile(
                                value: isActive,
                                enabled: editingMode,
                                onChanged: (value) {
                                  setState(() {
                                    isActive = value ?? false;
                                  });
                                },
                                title: const Text("active?"),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                decoration: const InputDecoration(
                                    helperText: "Enter any notes here."),
                                controller: notesTextController,
                                enabled: editingMode,
                                onChanged: (value) {
                                  setState(() {
                                    notes = value;
                                  });
                                },
                                maxLines: 10,
                                minLines: 6,
                              ),
                            ),
                          ])),
                    ),
                    const Spacer(),
                    // submitting the form
                    Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  DatabaseService instance =
                                      DatabaseService.instance();
                                  bool success =
                                      await instance.addDailyEntry(DailyEntry(
                                    epochDate: epochDate,
                                    isActive: isActive,
                                    notes: notes,
                                  ));
                                  if (success) {
                                    setState(() {
                                      loaded = false;
                                    });
                                  } else {
                                    Logger.warning(
                                        "Adding Daily Entry Failed: $epochDate, $isActive, $notes");
                                  }
                                },
                                child: const Text("Save")),
                            const SizedBox(width: 24),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(actions: [
                                          TextButton(
                                              onPressed: () => context.pop(),
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () async {
                                                DatabaseService instance =
                                                    DatabaseService.instance();
                                                bool success = await instance
                                                    .removeDailyEntry(
                                                        DailyEntry.generateId(
                                                            epochDate));
                                                if (!context.mounted) return;
                                                context.pop();
                                                Logger.info(
                                                    "Deleting entry E$epochDate: $success, proof: ${instance.getDailyEntry(epochDate)}");
                                                if (success) {
                                                  setState(() {
                                                    loaded = false;
                                                  });
                                                }
                                              },
                                              child: Text("Delete this Entry",
                                                  style: TextStyle(
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      color: Colors.white))),
                                        ]));
                              },
                            )
                          ]),
                    )
                  ])
                : const LoadingWidget()),
        bottomNavigationBar:
            const MoonbaseBottomBar(selectedIndex: EntryScreen.navIndex),
      ),
    );
  }
}
