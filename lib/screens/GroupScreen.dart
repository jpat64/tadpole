// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/components/LoadingWidget.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/components/MoonbaseEntryGroupCard.dart';
import 'package:moonbase/models/EntryGroup.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';

import 'package:intl/intl.dart';
import 'package:moonbase/utils/Palette.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key, required this.groupId});

  final int groupId;

  @override
  State<StatefulWidget> createState() => _GroupScreenState();

  static const String name = "/group";
  static const int navIndex = 2;
  static int defaultGroupId = DatabaseService.instance.mostRecentEntryGroup.id;
}

class _GroupScreenState extends State<GroupScreen> {
  DateTime? relevantDateTime;

  DateFormat dayMonthYear = DateFormat("MMMM d yyyy");

  TextEditingController nameTextController = TextEditingController();
  EntryGroup? group;
  List<DailyEntry>? entries;

  Palette? palette;
  bool? secretMode;
  int? previousId;
  int? nextId;

  bool editingMode = false;
  bool loaded = false;
  bool didAnythingChange = false;

  @override
  void initState() {
    super.initState();
  }

  void loadEntryGroup() {
    DatabaseService instance = DatabaseService.instance;
    EntryGroup? relevantEntryGroup =
        instance.getEntryGroupById(EntryGroup.generateId(widget.groupId));
    relevantEntryGroup ??= instance.mostRecentEntryGroup;
    List<DailyEntry>? relevantEntries =
        instance.getEntriesForGroup(EntryGroup.generateId(widget.groupId));
    setState(() {
      group = relevantEntryGroup!;
      nameTextController.text = group!.name;
      entries = relevantEntries;
    });
  }

  void loadAdjacentEntryGroups() {
    if (group != null) {
      DatabaseService instance = DatabaseService.instance;
      EntryGroup? previous = instance.getPreviousEntryGroup(group!);
      EntryGroup? next = instance.getNextEntryGroup(group!);
      setState(() {
        previousId = previous?.id;
        nextId = next?.id;
      });
    }
  }

  Future<void> loadPalette() async {
    Palette foundPalette = await Palette.currentPalette;
    setState(() {
      palette = foundPalette;
    });
  }

  Future<void> loadSecretModeToggle() async {
    bool foundSecretMode =
        await SharedPreferencesService.secretModeFlag ?? false;
    setState(() {
      secretMode = foundSecretMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      // only run if not loaded
      if (loaded == false) {
        loadEntryGroup();
        loadAdjacentEntryGroups();
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
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded,
                        color: palette?.text ?? Palette.basic.text),
                    onPressed: previousId == null
                        ? null
                        : () {
                            context.pushNamed(GroupScreen.name,
                                pathParameters: {"groupId": "$previousId"});
                          }),
                const Spacer(),
                Text(
                  group?.name ?? "Group",
                ),
                const Spacer(),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded,
                        color: palette?.text ?? Palette.basic.text),
                    onPressed: nextId == null
                        ? null
                        : () {
                            context.pushNamed(GroupScreen.name,
                                pathParameters: {"groupId": "$nextId"});
                          }),
              ],
            ),
          ),
        ),
        backgroundColor: palette?.background ?? Palette.basic.background,
        body: LayoutBuilder(
          builder: (context, constraints) => Container(
              padding: const EdgeInsets.all(16),
              child: loaded
                  ? ListView(children: [
                      Text(
                          "${secretMode ?? false ? "Cycles" : "Groups"} automatically update as you change them.",
                          style:
                              TextStyle(fontSize: 12, color: palette?.primary)),
                      Container(
                        padding: const EdgeInsets.all(24),
                        child: MoonbaseEntryGroupCard(
                          constraints: constraints,
                          editingMode: editingMode,
                          secretMode: secretMode ?? false,
                          palette: palette ?? Palette.basic,
                          entryGroupNameController: nameTextController,
                          entryGroupName: group?.name ?? "groupName",
                          entries: entries ?? [],
                          onNameChangedCallback: (name) {
                            setState(() {
                              didAnythingChange = true;
                              group?.name = name ?? "groupName";
                            });
                          },
                          onDailyEntryReassignCallback: (entry, newGroup) {
                            DatabaseService instance = DatabaseService.instance;
                            entry.entryGroupId =
                                EntryGroup.generateId(newGroup.id);
                            instance.addDailyEntry(entry);
                            setState(() {
                              entries?.removeWhere((element) =>
                                  element.epochDate == entry.epochDate);
                            });
                          },
                        ),
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
                                  child: Text(
                                      editingMode ? "Editing..." : "Edit",
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
                              IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: palette?.error,
                                    foregroundColor: palette?.background),
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title: ListTile(
                                                title: Text(
                                                    "Are you sure you want to delete this ${secretMode ?? false ? "Cycle" : "Group"}?"),
                                                subtitle: Text(
                                                    "We don't store your data anywhere else, so this is permanent unless you have made a backup.\n"
                                                    "Entries in this ${secretMode ?? false ? "Cycle" : "Group"} will be moved to the previous group, if available."),
                                                leading:
                                                    const Icon(Icons.warning),
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
                                                    onPressed: group != null
                                                        ? () async {
                                                            DatabaseService
                                                                instance =
                                                                DatabaseService
                                                                    .instance;
                                                            bool success =
                                                                await instance
                                                                    .deleteEntryGroup(
                                                                        group!);
                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }
                                                            context.pop();
                                                            Logger.info(
                                                                "Deleting group ${group?.id}: $success");
                                                            if (success) {
                                                              setState(() {
                                                                loaded = false;
                                                              });
                                                            }
                                                          }
                                                        : null,
                                                    child: Text(
                                                        "Delete this ${secretMode ?? false ? "Cycle" : "Group"}",
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
        ),
        bottomNavigationBar: MoonbaseBottomBar(
            palette: palette ?? Palette.basic,
            selectedIndex: GroupScreen.navIndex),
      ),
    );
  }
}
