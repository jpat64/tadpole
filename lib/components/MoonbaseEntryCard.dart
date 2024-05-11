// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/components/MoonbaseStatusButton.dart';
import 'package:moonbase/models/DailyEntryTag.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseEntryCard extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final bool editingMode;
  final int initialCurrent;
  final int initialPoints;
  final int initialPallor;
  final List<DailyEntryTag> initialTags;
  final TextEditingController textEditingController;
  final void Function(int?) currentOnChangedCallback;
  final void Function(int?) pointsOnChangedCallback;
  final void Function(int?) pallorOnChangedCallback;
  final void Function(DailyEntryTag) tagDeletedCallback;
  final void Function(DailyEntryTag?) searchOptionSelectedCallback;
  final List<DailyEntryTag> Function(String?) searchCallback;
  final void Function(String) textInputOnChangedCallback;

  const MoonbaseEntryCard({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.editingMode,
    required this.initialCurrent,
    required this.initialPoints,
    required this.initialPallor,
    required this.initialTags,
    required this.textEditingController,
    required this.currentOnChangedCallback,
    required this.pointsOnChangedCallback,
    required this.pallorOnChangedCallback,
    required this.tagDeletedCallback,
    required this.searchOptionSelectedCallback,
    required this.searchCallback,
    required this.textInputOnChangedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: backgroundColor,
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text("flow level:",
                            style: TextStyle(fontSize: 18, color: textColor))),
                    const Spacer(flex: 2),
                    Expanded(
                      flex: 6,
                      child: MoonbaseStatusButtonBar(
                        activeColor: Palette.red[500]!,
                        inactiveColor: Palette.gray[200]!,
                        initialValue: initialCurrent,
                        onPressedCallback: currentOnChangedCallback,
                        editingMode: editingMode,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(children: [
                  Expanded(
                      flex: 4,
                      child: Text("pain level:",
                          style: TextStyle(fontSize: 18, color: textColor))),
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 6,
                    child: MoonbaseStatusButtonBar(
                      activeColor: Palette.pink[500]!,
                      inactiveColor: Palette.gray[200]!,
                      initialValue: initialPoints,
                      onPressedCallback: pointsOnChangedCallback,
                      editingMode: editingMode,
                    ),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(children: [
                  Expanded(
                      flex: 4,
                      child: Text("mood level:",
                          style: TextStyle(fontSize: 18, color: textColor))),
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 6,
                    child: MoonbaseStatusButtonBar(
                      activeColor: Palette.purple[500]!,
                      inactiveColor: Palette.gray[200]!,
                      initialValue: initialPallor,
                      onPressedCallback: pallorOnChangedCallback,
                      editingMode: editingMode,
                    ),
                  )
                ]),
              ),
              Divider(color: Palette.tan[500]!),
              if (editingMode)
                Autocomplete(
                  optionsBuilder: (value) => searchCallback(value.text),
                  onSelected: searchOptionSelectedCallback,
                ),
              Wrap(
                children: initialTags
                    .map<FilterChip>(
                      (element) => FilterChip(
                        onSelected: (value) => {}, // do nothing
                        label: Text(element.text),
                        onDeleted: () {
                          tagDeletedCallback(element);
                        },
                      ),
                    )
                    .toList(),
              ),
              Divider(color: Palette.tan[500]!),
              Container(
                padding: const EdgeInsets.all(16),
                child: editingMode
                    ? TextField(
                        decoration: const InputDecoration(
                            helperText: "Enter any notes here."),
                        controller: textEditingController,
                        enabled: editingMode,
                        cursorErrorColor: Palette.red[500],
                        onChanged: textInputOnChangedCallback,
                        maxLines: 10,
                        minLines: 6,
                      )
                    : Text(textEditingController.text,
                        style: TextStyle(fontSize: 18, color: textColor)),
              ),
            ],
          ),
        ));
  }
}
