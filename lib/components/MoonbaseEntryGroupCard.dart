// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/components/MoonbaseEntryButton.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/models/EntryGroup.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseEntryGroupCard extends StatelessWidget {
  // fields for styling the component
  final BoxConstraints constraints;
  final Palette palette;
  final bool secretMode;
  final bool editingMode;

  // data fields for constructing the component
  final TextEditingController entryGroupNameController;
  final String entryGroupName;
  final List<DailyEntry> entries;

  // functions for changing the component's data
  final void Function(String?) onNameChangedCallback;
  final void Function(DailyEntry, EntryGroup) onDailyEntryReassignCallback;

  const MoonbaseEntryGroupCard({
    super.key,
    required this.constraints,
    required this.palette,
    required this.secretMode,
    required this.editingMode,
    required this.entryGroupNameController,
    required this.entryGroupName,
    required this.entries,
    required this.onNameChangedCallback,
    required this.onDailyEntryReassignCallback,
  });

  List<Widget> formatEntriesInGroup() {
    List<Widget> rows = <Widget>[];
    for (int i = 0; i < entries.length; i += 3) {
      List<Widget> buttonsToAdd = <Widget>[];
      for (int j = 0; (i + j < entries.length && j < 3); j++) {
        buttonsToAdd.add(
          SizedBox(
            height: constraints.biggest.height * 0.175,
            width: constraints.biggest.width * 0.25,
            child: MoonbaseEntryButton(
              palette: palette,
              entry: entries[i + j],
              secretMode: secretMode,
              onDailyEntryReassignCallback: onDailyEntryReassignCallback,
            ),
          ),
        );
      }
      rows.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buttonsToAdd,
          ),
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
            editingMode
                ? TextField(
                    controller: entryGroupNameController,
                    enabled: editingMode,
                    cursorErrorColor: palette.error,
                    onChanged: onNameChangedCallback,
                    minLines: 1,
                    style: TextStyle(fontSize: 18, color: palette.text),
                  )
                : ListTile(
                    title: Text(entryGroupNameController.text,
                        style: TextStyle(fontSize: 18, color: palette.text)),
                  ),
            Divider(color: palette.primary),
          ] +
          formatEntriesInGroup(),
    );
  }
}
