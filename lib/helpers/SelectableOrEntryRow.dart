// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/models/EntryModel.dart';

ListTile selectableOrEntryRow({
  required ListCandidate listItem,
  required bool checked,
  void Function()? checkedCallback,
  required bool editable,
  void Function()? deleteCallback,
  String? text,
  void Function()? addNewCallback,
}) {
  return ListTile(
    leading: checked
        ? const Icon(Icons.check_box)
        : const Icon(Icons.check_box_outline_blank),
    trailing: editable
        ? null
        : ElevatedButton(
            onPressed: deleteCallback,
            child: const Icon(Icons.delete_forever),
          ),
    onTap: editable ? null : checkedCallback,
    title: editable
        ? TextField(
            onChanged: (value) {
              text = value;
              addNewCallback!();
            },
          )
        : Text(text ?? "<editable item, but no given text>"),
  );
}
