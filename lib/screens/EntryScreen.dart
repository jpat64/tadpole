// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/components/LoadingWidget.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/components/MoonbaseEntryCard.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';

import 'package:intl/intl.dart';
import 'package:moonbase/utils/Palette.dart';

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

  DateFormat dayMonthYear = DateFormat("MMMM d yyyy");

  TextEditingController notesTextController = TextEditingController();
  late String notes;
  late final int epochDate;
  late int current;
  late int points;
  late int pallor;

  bool editingMode = false;
  bool loaded = false;
  bool didAnythingChange = false;

  @override
  void initState() {
    super.initState();

    relevantDateTime = DateTimeUtils.dateFromEpochDays(widget.epochDate);
    epochDate = DateTimeUtils.epochDays(relevantDateTime!);
  }

  void loadDailyEntry() {
    DatabaseService instance = DatabaseService.instance();
    bool isEntryActive = instance.existsEntryForDay(epochDate);
    DailyEntry? relevantEntry;
    if (isEntryActive) {
      relevantEntry = instance.getDailyEntry(epochDate);
    }
    setState(() {
      if (relevantEntry == null) {
        didAnythingChange = true;
        current = 0;
        points = 0;
        pallor = 0;
        notes = "";
        notesTextController.text = "";
      } else {
        current = relevantEntry.current;
        points = relevantEntry.points;
        pallor = relevantEntry.pallor;
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
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayMonthYear.format(relevantDateTime!),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor:
                            editingMode ? Palette.white : Palette.black,
                        backgroundColor: editingMode
                            ? Palette.blue[500]
                            : Palette.orange[100]!),
                    child: Text(editingMode ? "Editing..." : "Edit",
                        style: !editingMode
                            ? const TextStyle(
                                decoration: TextDecoration.underline)
                            : null),
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
                ? ListView(children: [
                    MoonbaseEntryCard(
                        textColor: Palette.black,
                        backgroundColor: Palette.tan[100]!,
                        accentColor: Palette.blue[500]!,
                        editingMode: editingMode,
                        initialCurrent: current,
                        initialPoints: points,
                        initialPallor: pallor,
                        textEditingController: notesTextController,
                        currentOnChangedCallback: (value) {
                          setState(() {
                            didAnythingChange = true;
                            current = value ?? 0;
                          });
                        },
                        pointsOnChangedCallback: (value) {
                          setState(() {
                            didAnythingChange = true;
                            points = value ?? 0;
                          });
                        },
                        pallorOnChangedCallback: (value) {
                          setState(() {
                            didAnythingChange = true;
                            pallor = value ?? 0;
                          });
                        },
                        textInputOnChangedCallback: (value) {
                          setState(() {
                            didAnythingChange = true;
                            notes = value;
                          });
                        }),
                    const SizedBox(height: 24),
                    // submitting the form
                    Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (didAnythingChange)
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Palette.blue[500]),
                                  onPressed: () async {
                                    DatabaseService instance =
                                        DatabaseService.instance();
                                    bool success =
                                        await instance.addDailyEntry(DailyEntry(
                                      epochDate: epochDate,
                                      current: current,
                                      points: points,
                                      pallor: pallor,
                                      notes: notes,
                                    ));
                                    if (success) {
                                      setState(() {
                                        loaded = false;
                                        editingMode = false;
                                        didAnythingChange = false;
                                      });
                                    } else {
                                      Logger.warning(
                                          "Adding Daily Entry Failed: $epochDate, [$current, $points, $pallor], $notes");
                                    }
                                  },
                                  child: const Text("Save",
                                      style: TextStyle(color: Palette.white))),
                            const SizedBox(width: 24),
                            IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: Palette.red[500],
                                  foregroundColor: Palette.white),
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            title: const ListTile(
                                              title: Text(
                                                  "Are you sure you want to delete this Entry?"),
                                              subtitle: Text(
                                                  "We don't store your data anywhere else, so this is permanent unless you have made a backup."),
                                              leading: Icon(Icons.warning),
                                            ),
                                            actions: [
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Palette.blue[500],
                                                  ),
                                                  onPressed: () =>
                                                      context.pop(),
                                                  child: const Text("Cancel",
                                                      style: TextStyle(
                                                          color:
                                                              Palette.white))),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Palette.red[500],
                                                  ),
                                                  onPressed: () async {
                                                    DatabaseService instance =
                                                        DatabaseService
                                                            .instance();
                                                    bool success = await instance
                                                        .removeDailyEntry(
                                                            DailyEntry
                                                                .generateId(
                                                                    epochDate));
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    context.pop();
                                                    Logger.info(
                                                        "Deleting entry E$epochDate: $success, proof: ${instance.getDailyEntry(epochDate)}");
                                                    if (success) {
                                                      setState(() {
                                                        loaded = false;
                                                      });
                                                    }
                                                  },
                                                  child: const Text(
                                                      "Delete this Entry",
                                                      style: TextStyle(
                                                          color:
                                                              Palette.white))),
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
