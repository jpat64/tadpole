// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moonbase/components/MoonbaseBadgeSection.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/models/EntryGroup.dart';
import 'package:moonbase/screens/EntryScreen.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseEntryButton extends StatefulWidget {
  final Palette palette;
  final bool secretMode;
  final DailyEntry entry;

  final void Function(DailyEntry, EntryGroup) onDailyEntryReassignCallback;

  const MoonbaseEntryButton({
    super.key,
    required this.entry,
    required this.palette,
    required this.secretMode,
    required this.onDailyEntryReassignCallback,
  });

  @override
  State<MoonbaseEntryButton> createState() => _MoonbaseEntryButtonState();
}

class _MoonbaseEntryButtonState extends State<MoonbaseEntryButton> {
  late DailyEntry entry;
  late Palette palette;
  late bool secretMode;
  late void Function(DailyEntry, EntryGroup) onDailyEntryReassignCallback;

  EntryGroup? selectedEntryGroup;

  final DateFormat entryGroupMonthFormat = DateFormat("MMMM");
  final DateFormat entryGroupDateFormat = DateFormat("d");

  @override
  void initState() {
    super.initState();

    entry = widget.entry;
    palette = widget.palette;
    secretMode = widget.secretMode;
    onDailyEntryReassignCallback = widget.onDailyEntryReassignCallback;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> badgeColors = <Color>[];
    if (entry.secured ?? false) {
      badgeColors.add(palette.accent);
    }
    if ((entry.current) > 1 || (entry.points) > 1 || (entry.pallor) > 1) {
      badgeColors.add(palette.splash);
    }
    if ((entry.tags?.isNotEmpty ?? false) ||
        (entry.notes?.isNotEmpty ?? false)) {
      badgeColors.add(palette.primary);
    }

    return Card(
      color: palette.secondary,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: palette.secondary),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15))),
      child: Column(
        children: [
          Text(
            entryGroupMonthFormat.format(
              DateTimeUtils.dateFromEpochDays(entry.epochDate),
            ),
            style: TextStyle(fontSize: 12, color: palette.text),
          ),
          const SizedBox(height: 4),
          Text(
            entryGroupDateFormat.format(
              DateTimeUtils.dateFromEpochDays(entry.epochDate),
            ),
            style: TextStyle(fontSize: 20, color: palette.text),
          ),
          const SizedBox(height: 4),
          MoonbaseBadgeSection(
            badgeColors: badgeColors,
            sizes: const <double>[0, 12, 12, 12],
          ),
          Row(children: [
            IconButton(
                style: IconButton.styleFrom(backgroundColor: palette.primary),
                icon: Icon(Icons.question_mark, color: palette.background),
                onPressed: () {
                  // open dialog that lets you remove this entry from the list
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: palette.secondary,
                      content: Column(
                        children: <Widget>[
                              Text(
                                  "Move this Entry to a different ${secretMode ? "Cycle" : "Group"}?")
                            ] +
                            DatabaseService.instance.entryGroups
                                .map<Widget>((element) => ListTile(
                                    title: Text(element.name),
                                    selected:
                                        selectedEntryGroup?.id == element.id,
                                    selectedColor: palette.background,
                                    selectedTileColor: palette.primary,
                                    onTap: () {
                                      setState(() {
                                        selectedEntryGroup = element;
                                      });
                                    }))
                                .toList(),
                      ),
                      actions: [
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: palette.primary,
                            ),
                            onPressed: () => context.pop(),
                            child: Text("Cancel",
                                style: TextStyle(color: palette.background))),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: palette.error,
                          ),
                          onPressed: selectedEntryGroup != null
                              ? () => onDailyEntryReassignCallback(
                                  entry, selectedEntryGroup!)
                              : null,
                          child: Text(
                            "Move Entry",
                            style: TextStyle(color: palette.background),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            IconButton(
              style: IconButton.styleFrom(backgroundColor: palette.accent),
              icon: Icon(Icons.arrow_forward, color: palette.background),
              onPressed: () => context.goNamed(EntryScreen.name,
                  pathParameters: {"epochDate": "${entry.epochDate}"}),
            ),
          ])
        ],
      ),
    );
  }
}
