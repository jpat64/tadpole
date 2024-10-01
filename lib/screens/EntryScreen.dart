// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/components/LoadingWidget.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/components/MoonbaseEntryCard.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/models/DailyEntryTag.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';
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
  static int defaultEpochDate =
      DateTimeUtils.epochDays(DateUtils.addDaysToDate(DateTime.now(), 0));
}

class _EntryScreenState extends State<EntryScreen> {
  DateTime? relevantDateTime;

  DateFormat dayMonthYear = DateFormat("MMMM d yyyy");

  TextEditingController notesTextController = TextEditingController();
  TextEditingController groupNameEditingController = TextEditingController();
  late String notes;
  late final int epochDate;
  late bool secured;
  late int current;
  late int points;
  late int pallor;
  late List<DailyEntryTag> tags;
  late String entryGroupName;

  Palette? palette;
  bool? secretMode;

  bool createNewGroup = false;
  bool editingMode = false;
  bool loaded = false;
  bool didAnythingChange = false;

  @override
  void initState() {
    super.initState();

    relevantDateTime = DateTimeUtils.dateFromEpochDays(widget.epochDate);
    epochDate = DateTimeUtils.epochDays(relevantDateTime!);
  }

  Future<void> loadSecretModeToggle() async {
    bool foundSecretMode =
        await SharedPreferencesService.secretModeFlag ?? false;
    setState(() {
      secretMode = foundSecretMode;
    });
  }

  void loadDailyEntry() {
    DatabaseService instance = DatabaseService.instance;
    bool isEntryActive = instance.existsEntryForDay(epochDate);
    DailyEntry? relevantEntry;
    if (isEntryActive) {
      relevantEntry = instance.getDailyEntry(epochDate);
    }
    setState(() {
      if (relevantEntry == null) {
        didAnythingChange = true;
        secured = false;
        current = 0;
        points = 0;
        pallor = 0;
        tags = <DailyEntryTag>[];
        notes = "";
        notesTextController.text = "";
        entryGroupName = DailyEntry.defaultEntryGroupName;
      } else {
        secured = relevantEntry.secured ?? false;
        current = relevantEntry.current;
        points = relevantEntry.points;
        pallor = relevantEntry.pallor;
        tags = relevantEntry.tags ?? <DailyEntryTag>[];
        notes = relevantEntry.notes ?? "";
        notesTextController.text = notes;
        entryGroupName = relevantEntry.entryGroupName;
      }
    });
  }

  Future<void> loadPalette() async {
    Palette foundPalette = await Palette.currentPalette;
    setState(() {
      palette = foundPalette;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      // only run if not loaded
      if (loaded == false) {
        loadDailyEntry();
        await loadPalette();
        await loadSecretModeToggle();
        setState(() {
          loaded = true;
        });
      }
    });

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: palette?.iconTheme,
          backgroundColor: palette?.background,
          titleTextStyle: palette?.titleTextTheme,
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded,
                        color: palette?.text ?? Palette.basic.text),
                    onPressed: () {
                      if (relevantDateTime != null) {
                        DateTime lastDay =
                            DateUtils.addDaysToDate(relevantDateTime!, -1);

                        context.pushNamed(EntryScreen.name, pathParameters: {
                          "epochDate": "${DateTimeUtils.epochDays(lastDay)}"
                        });
                      }
                    }),
                const Spacer(),
                Text(dayMonthYear.format(relevantDateTime!),
                    style: const TextStyle(fontFamily: "Freeman")),
                const Spacer(),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded,
                        color: palette?.text ?? Palette.basic.text),
                    onPressed: () {
                      if (relevantDateTime != null) {
                        DateTime nextDay =
                            DateUtils.addDaysToDate(relevantDateTime!, 1);
                        context.pushNamed(EntryScreen.name, pathParameters: {
                          "epochDate": "${DateTimeUtils.epochDays(nextDay)}"
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
        backgroundColor: palette?.background ?? Palette.basic.background,
        body: Container(
            padding: const EdgeInsets.all(16),
            child: loaded
                ? ListView(children: [
                    MoonbaseEntryCard(
                      palette: palette ?? Palette.basic,
                      editingMode: editingMode,
                      initialSecured: secured,
                      initialNewEntryGroup: createNewGroup,
                      initialGroupName: entryGroupName,
                      initialCurrent: current,
                      initialPoints: points,
                      initialPallor: pallor,
                      initialTags: tags,
                      notesEditingController: notesTextController,
                      groupNameEditingController: groupNameEditingController,
                      securedOnChangedCallback: (value) {
                        setState(() {
                          didAnythingChange = true;
                          secured = value ?? false;
                        });
                      },
                      newEntryGroupOnChangedCallback: (value) {
                        setState(() {
                          didAnythingChange = true;
                          createNewGroup = value ?? false;
                        });
                      },
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
                      tagDeletedCallback: (entryTag) {
                        if (tags.contains(entryTag)) {
                          setState(() {
                            didAnythingChange = true;
                            tags.remove(entryTag);
                          });
                        }
                      },
                      searchCallback: (searchString) {
                        if (searchString?.isNotEmpty ?? false) {
                          DatabaseService instance = DatabaseService.instance;
                          return instance
                              .searchTags(searchString!)
                              .where(
                                (element) => (tags
                                        .map<String>(
                                            (subelement) => subelement.id)
                                        .contains(element.id) ==
                                    false),
                              )
                              .toList();
                        }
                        return [];
                      },
                      searchOptionSelectedCallback: (entryTag) {
                        if (entryTag != null) {
                          String filteredTagText = entryTag.text;
                          if (entryTag.text.startsWith("create new tag \"") &&
                              entryTag.text.endsWith("\"")) {
                            filteredTagText = entryTag.text.substring(
                                "create new tag \"".length,
                                entryTag.text.length - 1);
                          }
                          if (tags
                                  .map<String>((element) => element.text)
                                  .contains(filteredTagText) ==
                              false) {
                            setState(() {
                              didAnythingChange = true;
                              tags.add(DailyEntryTag(
                                  id: entryTag.id, text: filteredTagText));
                            });
                          }
                        }
                      },
                      textInputOnChangedCallback: (value) {
                        setState(() {
                          didAnythingChange = true;
                          notes = value;
                        });
                      },
                      groupNameOnChangedCallback: (value) {
                        setState(() {
                          didAnythingChange = true;
                          entryGroupName = value ?? entryGroupName;
                        });
                      },
                      secretMode: secretMode ?? false,
                    ),
                    const SizedBox(height: 24),
                    // submitting the form
                    Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: palette?.background,
                                    backgroundColor: editingMode
                                        ? palette?.accent
                                        : palette?.primary),
                                child: Text(editingMode ? "Editing..." : "Edit",
                                    style: !editingMode
                                        ? const TextStyle(
                                            decoration:
                                                TextDecoration.underline)
                                        : null),
                                onPressed: () {
                                  setState(() {
                                    editingMode = !editingMode;
                                  });
                                }),
                            const Spacer(),
                            if (didAnythingChange)
                              TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: palette?.accent,
                                  ),
                                  onPressed: () async {
                                    DatabaseService instance =
                                        DatabaseService.instance;

                                    bool success = false;

                                    // see if this entry is trying to make a new group with an existing name
                                    if (createNewGroup &&
                                        instance.sortedEntryGroups
                                            .where((element) =>
                                                element.name == entryGroupName)
                                            .isNotEmpty) {
                                      Logger.warning(
                                          "EntryScreen.save() entry is trying to make a new group but a group already exists with the name $entryGroupName");
                                      return;
                                    }

                                    // save any new tags
                                    List<String>? tagsTextsList;
                                    for (DailyEntryTag tag in tags) {
                                      if (tag.id.startsWith("newTag")) {
                                        tagsTextsList ??= [];
                                        tagsTextsList.add(tag.text);
                                      }
                                    }
                                    if (tagsTextsList?.isNotEmpty ?? false) {
                                      success = await instance
                                          .addTags(tagsTextsList!);
                                      if (!success) {
                                        Logger.warning(
                                            "Adding Daily Entry Tags Failed: $tagsTextsList");
                                      }
                                    }

                                    // save current entry
                                    DailyEntry newEntry = DailyEntry(
                                      epochDate: epochDate,
                                      secured: secured,
                                      current: current,
                                      points: points,
                                      pallor: pallor,
                                      tags: tags,
                                      notes: notes,
                                      entryGroupName: entryGroupName,
                                    );

                                    success =
                                        await instance.addDailyEntry(newEntry);

                                    if (success) {
                                      setState(() {
                                        loaded = false;
                                        editingMode = false;
                                        createNewGroup = false;
                                        didAnythingChange = false;
                                      });
                                    } else {
                                      Logger.warning(
                                          "Adding Daily Entry Failed: $epochDate, [$current, $points, $pallor], $notes");
                                    }
                                  },
                                  child: Text("Save",
                                      style: TextStyle(
                                          color: palette?.background))),
                            const SizedBox(width: 24),
                            IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: palette?.error,
                                  foregroundColor: palette?.background),
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
                                                        palette?.primary,
                                                  ),
                                                  onPressed: () =>
                                                      context.pop(),
                                                  child: Text("Cancel",
                                                      style: TextStyle(
                                                          color: palette
                                                              ?.background))),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        palette?.error,
                                                  ),
                                                  onPressed: () async {
                                                    DatabaseService instance =
                                                        DatabaseService
                                                            .instance;
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
                                                  child: Text(
                                                      "Delete this Entry",
                                                      style: TextStyle(
                                                          color: palette
                                                              ?.background))),
                                            ]));
                              },
                            )
                          ]),
                    )
                  ])
                : const LoadingWidget()),
        bottomNavigationBar: MoonbaseBottomBar(
            palette: palette ?? Palette.basic,
            selectedIndex: EntryScreen.navIndex),
      ),
    );
  }
}
