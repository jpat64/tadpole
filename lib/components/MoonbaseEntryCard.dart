// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/components/MoonbaseStatusButton.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseEntryCard extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final bool editingMode;
  final int initialCurrent;
  final int initialPoints;
  final int initialPallor;
  final TextEditingController textEditingController;
  final void Function(int?) currentOnChangedCallback;
  final void Function(int?) pointsOnChangedCallback;
  final void Function(int?) pallorOnChangedCallback;
  final void Function(String) textInputOnChangedCallback;

  const MoonbaseEntryCard({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.accentColor,
    required this.editingMode,
    required this.initialCurrent,
    required this.initialPoints,
    required this.initialPallor,
    required this.textEditingController,
    required this.currentOnChangedCallback,
    required this.pointsOnChangedCallback,
    required this.pallorOnChangedCallback,
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
              child: Row(children: [
                Expanded(
                    flex: 4,
                    child: Text("flow level:",
                        style: TextStyle(fontSize: 18, color: textColor))),
                const Spacer(flex: 2),
                Expanded(
                    flex: 6,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MoonbaseStatusButton(
                            currentLevel: initialCurrent,
                            targetLevel: 0,
                            activeColor: Palette.red[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                currentOnChangedCallback(0);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialCurrent,
                            targetLevel: 1,
                            activeColor: Palette.red[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                currentOnChangedCallback(1);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialCurrent,
                            targetLevel: 2,
                            activeColor: Palette.red[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                currentOnChangedCallback(2);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialCurrent,
                            targetLevel: 3,
                            activeColor: Palette.red[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                currentOnChangedCallback(3);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialCurrent,
                            targetLevel: 4,
                            activeColor: Palette.red[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                currentOnChangedCallback(4);
                              }
                            },
                          ),
                        ]))
              ]),
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MoonbaseStatusButton(
                            currentLevel: initialPoints,
                            targetLevel: 0,
                            activeColor: Palette.pink[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pointsOnChangedCallback(0);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialPoints,
                            targetLevel: 1,
                            activeColor: Palette.pink[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pointsOnChangedCallback(1);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialPoints,
                            targetLevel: 2,
                            activeColor: Palette.pink[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pointsOnChangedCallback(2);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialPoints,
                            targetLevel: 3,
                            activeColor: Palette.pink[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pointsOnChangedCallback(3);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialPoints,
                            targetLevel: 4,
                            activeColor: Palette.pink[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pointsOnChangedCallback(4);
                              }
                            },
                          ),
                        ]))
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MoonbaseStatusButton(
                            currentLevel: initialPallor,
                            targetLevel: 0,
                            activeColor: Palette.purple[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pallorOnChangedCallback(0);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialPallor,
                            targetLevel: 1,
                            activeColor: Palette.purple[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pallorOnChangedCallback(1);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialPallor,
                            targetLevel: 2,
                            activeColor: Palette.purple[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pallorOnChangedCallback(2);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialPallor,
                            targetLevel: 3,
                            activeColor: Palette.purple[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pallorOnChangedCallback(3);
                              }
                            },
                          ),
                          MoonbaseStatusButton(
                            currentLevel: initialPallor,
                            targetLevel: 4,
                            activeColor: Palette.purple[500]!,
                            inactiveColor: Palette.gray[200]!,
                            onPressedCallback: () {
                              if (editingMode) {
                                pallorOnChangedCallback(4);
                              }
                            },
                          ),
                        ]))
              ]),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: editingMode
                  ? TextField(
                      decoration: const InputDecoration(
                          helperText: "Enter any notes here."),
                      controller: textEditingController,
                      enabled: editingMode,
                      cursorColor: accentColor,
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
      ),
    );
  }
}
