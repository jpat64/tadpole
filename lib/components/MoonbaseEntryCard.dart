// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseEntryCard extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final bool editingMode;
  final bool initialActive;
  final TextEditingController textEditingController;
  final void Function(bool?) checkboxOnChangedCallback;
  final void Function(String) textInputOnChangedCallback;

  const MoonbaseEntryCard({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.accentColor,
    required this.editingMode,
    required this.initialActive,
    required this.textEditingController,
    required this.checkboxOnChangedCallback,
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
              child: CheckboxListTile(
                activeColor: accentColor,
                checkColor: Palette.white,
                value: initialActive,
                enabled: editingMode,
                onChanged: checkboxOnChangedCallback,
                title: Text("active?",
                    style: TextStyle(fontSize: 18, color: textColor)),
              ),
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
