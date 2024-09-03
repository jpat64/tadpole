// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/components/MoonbaseStatusButton.dart';
import 'package:moonbase/models/DailyEntryTag.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MoonbaseEntryCard extends StatelessWidget {
  final Palette palette;
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
    required this.palette,
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
        color: palette.secondary,
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
                        style: TextStyle(fontSize: 18, color: palette.text)),
                    MoonbaseStatusButton(
                      activeColor: palette.accent,
                      zeroColor: palette.disabled,
                      currentLevel: initialSecured ? 4 : 0,
                      targetLevel: 4,
                      inactiveColor: palette.disabled,
                      onPressedCallback: () {
                        if (editingMode) {
                          securedOnChangedCallback(!initialSecured);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: palette.primary),
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text("flow level:",
                            style:
                                TextStyle(fontSize: 18, color: palette.text))),
                    const Spacer(flex: 2),
                    Expanded(
                      flex: 6,
                      child: MoonbaseStatusButtonBar(
                        activeColor: palette.splash,
                        inactiveColor: palette.disabled,
                        dividerColor: palette.primary,
                        zeroColor: palette.text,
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
                          style: TextStyle(fontSize: 18, color: palette.text))),
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 6,
                    child: MoonbaseStatusButtonBar(
                      activeColor: palette.splash,
                      inactiveColor: palette.disabled,
                      dividerColor: palette.primary,
                      zeroColor: palette.text,
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
                          style: TextStyle(fontSize: 18, color: palette.text))),
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 6,
                    child: MoonbaseStatusButtonBar(
                      activeColor: palette.splash,
                      inactiveColor: palette.disabled,
                      dividerColor: palette.primary,
                      zeroColor: palette.text,
                      initialValue: initialPallor,
                      onPressedCallback: pallorOnChangedCallback,
                      editingMode: editingMode,
                    ),
                  )
                ]),
              ),
              Divider(color: palette.primary),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("tags:",
                    style: TextStyle(fontSize: 18, color: palette.text)),
                Badge(
                  smallSize: 24,
                  backgroundColor: (editingMode && initialTags.isNotEmpty)
                      ? palette.accent
                      : palette.disabled,
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
                          backgroundColor: palette.accent,
                          deleteIconColor: palette.text,
                          onSelected: (value) => {}, // do nothing
                          shape: StadiumBorder(
                              side: BorderSide(color: palette.accent)),
                          label: Text(element.text,
                              style:
                                  TextStyle(color: palette.text, fontSize: 16)),
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
                            color: palette.disabled,
                            fontStyle: FontStyle.italic))),
              Divider(color: palette.primary),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("notes:",
                    style: TextStyle(fontSize: 18, color: palette.text)),
                Badge(
                  smallSize: 24,
                  backgroundColor:
                      editingMode || textEditingController.text.isNotEmpty
                          ? palette.primary
                          : palette.disabled,
                )
              ]),
              editingMode
                  ? TextField(
                      controller: textEditingController,
                      enabled: editingMode,
                      cursorErrorColor: palette.error,
                      onChanged: textInputOnChangedCallback,
                      maxLines: 10,
                      minLines: 6,
                      style: TextStyle(color: palette.text),
                    )
                  : ListTile(
                      title: textEditingController.text.isNotEmpty
                          ? Text(textEditingController.text,
                              style:
                                  TextStyle(fontSize: 18, color: palette.text))
                          : Text(
                              "No notes yet for this entry.",
                              style: TextStyle(
                                  color: palette.disabled,
                                  fontStyle: FontStyle.italic),
                            ),
                    ),
            ],
          ),
        ));
  }
}
