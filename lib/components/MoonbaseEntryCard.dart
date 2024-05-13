// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/components/MoonbaseStatusButton.dart';
import 'package:moonbase/models/DailyEntryTag.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MoonbaseEntryCard extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final bool editingMode;
  final bool initialSecured;
  final int initialCurrent;
  final int initialPoints;
  final int initialPallor;
  final List<DailyEntryTag> initialTags;
  final TextEditingController textEditingController;
  final void Function(bool?) securedOnChangedCallback;
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
    required this.initialSecured,
    required this.initialCurrent,
    required this.initialPoints,
    required this.initialPallor,
    required this.initialTags,
    required this.textEditingController,
    required this.securedOnChangedCallback,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("medication taken:",
                        style: TextStyle(fontSize: 18, color: textColor)),
                    MoonbaseStatusButton(
                      activeColor: Palette.orange[500]!,
                      currentLevel: initialSecured ? 4 : 0,
                      targetLevel: 4,
                      inactiveColor: Palette.gray[200]!,
                      onPressedCallback: () {
                        if (editingMode) {
                          securedOnChangedCallback(!initialSecured);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: Palette.tan[500]!),
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
                        dividerColor: Palette.tan[500]!,
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
                      dividerColor: Palette.tan[500]!,
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
                      dividerColor: Palette.tan[500]!,
                      initialValue: initialPallor,
                      onPressedCallback: pallorOnChangedCallback,
                      editingMode: editingMode,
                    ),
                  )
                ]),
              ),
              Divider(color: Palette.tan[500]!),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("tags:", style: TextStyle(fontSize: 18, color: textColor)),
                Badge(
                  smallSize: 24,
                  backgroundColor: editingMode || initialTags.isNotEmpty
                      ? Palette.green[500]!
                      : Palette.gray[200]!,
                )
              ]),
              if (editingMode)
                TypeAheadField<DailyEntryTag>(
                    builder: (context, controller, focusNode) => TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                            hintText: "Enter a tag here...")),
                    suggestionsCallback: (searchString) {
                      List<DailyEntryTag>? searchResults =
                          searchCallback(searchString);
                      searchResults.add(DailyEntryTag(
                          id: "newTag",
                          text: "create new tag \"$searchString\""));
                      return searchResults;
                    },
                    onSelected: searchOptionSelectedCallback,
                    itemBuilder: (context, value) =>
                        ListTile(title: Text(value.text))),
              if (initialTags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  children: initialTags
                      .map<FilterChip>(
                        (element) => FilterChip(
                          backgroundColor: Palette.green[500]!,
                          deleteIconColor: Palette.white,
                          onSelected: (value) => {}, // do nothing
                          shape: StadiumBorder(
                              side: BorderSide(color: Palette.green[500]!)),
                          label: Text(element.text,
                              style: const TextStyle(
                                  color: Palette.white, fontSize: 16)),
                          onDeleted: editingMode
                              ? () {
                                  tagDeletedCallback(element);
                                }
                              : null,
                        ),
                      )
                      .toList(),
                ),
              if (initialTags.isEmpty)
                ListTile(
                    title: Text("No tags yet for this entry.",
                        style: TextStyle(
                            color: Palette.gray[400]!,
                            fontStyle: FontStyle.italic))),
              Divider(color: Palette.tan[500]!),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("notes:",
                    style: TextStyle(fontSize: 18, color: textColor)),
                Badge(
                  smallSize: 24,
                  backgroundColor:
                      editingMode || textEditingController.text.isNotEmpty
                          ? Palette.blue[500]!
                          : Palette.gray[200]!,
                )
              ]),
              editingMode
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
                  : ListTile(
                      title: textEditingController.text.isNotEmpty
                          ? Text(textEditingController.text,
                              style: TextStyle(fontSize: 18, color: textColor))
                          : Text(
                              "No notes yet for this entry.",
                              style: TextStyle(
                                  color: Palette.gray[400]!,
                                  fontStyle: FontStyle.italic),
                            ),
                    ),
            ],
          ),
        ));
  }
}
