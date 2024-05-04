// ignore_for_file: file_names

import 'package:flutter/material.dart';

// always returns 6 lists of 7 strings, with the strings being the day
List<List<String>> arrangeMonth(DateTime? dateTime) {
  dateTime ??= DateTime.now();

  // week format:   S M T W R F S
  // in ISO:        7 1 2 3 4 5 6
  // want it to be: 0 1 2 3 4 5 6
  int daysInMonth = DateUtils.getDaysInMonth(dateTime.year, dateTime.month);
  int dateOffset = DateUtils.firstDayOffset(
      dateTime.year, dateTime.month, const DefaultMaterialLocalizations());
  List<String> daysAsOneList = List.filled(42, "--");
  // the above took me like 5 hours to find and caused such a headache
  for (int i = 0; i < daysInMonth; i++) {
    String extra = "";
    if (i + 1 == dateTime.day) {
      extra = "!";
    }
    daysAsOneList[(i + dateOffset)] = "${i + 1}$extra";
  }
  return [
    daysAsOneList.getRange(0, 7).toList(),
    daysAsOneList.getRange(7, 14).toList(),
    daysAsOneList.getRange(14, 21).toList(),
    daysAsOneList.getRange(21, 28).toList(),
    daysAsOneList.getRange(28, 35).toList(),
    daysAsOneList.getRange(35, 42).toList(),
  ];
}
