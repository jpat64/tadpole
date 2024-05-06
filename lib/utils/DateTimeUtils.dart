// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/utils/Tuple.dart';

class DateTimeUtils {
  static int epochDays(DateTime dateTime) {
    return (dateTime.millisecondsSinceEpoch / (86400 * 1000)).ceil();
  }

  static DateTime dateFromEpochDays(int epochDays) {
    return DateTime.fromMillisecondsSinceEpoch(epochDays * 86400 * 1000);
  }

  // always returns 6 lists of 7 strings, with the strings being the day
  static List<List<Tuple<String, DateTime>>> arrangeMonth(DateTime? dateTime) {
    dateTime ??= DateTime.now();

    // week format:   S M T W R F S
    // in ISO:        7 1 2 3 4 5 6
    // want it to be: 0 1 2 3 4 5 6
    int daysInMonth = DateUtils.getDaysInMonth(dateTime.year, dateTime.month);
    int dateOffset = DateUtils.firstDayOffset(
        dateTime.year, dateTime.month, const DefaultMaterialLocalizations());
    DateTime dayZeroOfMonth = DateUtils.addDaysToDate(dateTime, -dateTime.day);
    List<Tuple<String, DateTime>> daysAsOneList =
        List.filled(42, Tuple("--", dayZeroOfMonth));
    // the above took me like 5 hours to find and caused such a headache
    for (int i = 0; i < daysInMonth; i++) {
      daysAsOneList[(i + dateOffset)] =
          Tuple("${i + 1}", DateUtils.addDaysToDate(dayZeroOfMonth, (i + 1)));
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
}
