// ignore_for_file: file_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moonbase/utils/data/Pair.dart';

class DateTimeUtils {
  static const int MILLIS_PER_DAY = 86400 * 1000;

  static DateFormat dateFormat =
      DateFormat(DateFormat.YEAR_MONTH_DAY.replaceAll(",", ""));

  static int epochDays(DateTime dateTime) {
    return (dateTime.millisecondsSinceEpoch / MILLIS_PER_DAY).ceil();
  }

  static int epochDaysFromString(String dateString) {
    return epochDays(DateTime.parse(dateString));
  }

  static String stringFromEpochDays(int epochDays) {
    return dateFormat.format(dateFromEpochDays(epochDays));
  }

  static DateTime dateFromEpochDays(int epochDays) {
    return DateTime.fromMillisecondsSinceEpoch(epochDays * MILLIS_PER_DAY);
  }

  // always returns 6 lists of 7 strings, with the strings being the day
  static List<List<Pair<String, DateTime>>> arrangeMonth(DateTime? dateTime) {
    dateTime ??=
        DateUtils.addDaysToDate(DateTime.now(), 0); // today at midnight

    int daysInMonth = DateUtils.getDaysInMonth(dateTime.year, dateTime.month);
    int dateOffset = DateUtils.firstDayOffset(
        dateTime.year, dateTime.month, const DefaultMaterialLocalizations());
    DateTime dayZeroOfMonth = DateUtils.addDaysToDate(dateTime, -dateTime.day);
    List<Pair<String, DateTime>> daysAsOneList =
        List.filled(42, Pair("--", dayZeroOfMonth));
    // the above took me like 5 hours to find and caused such a headache
    for (int i = 0; i < daysInMonth; i++) {
      daysAsOneList[(i + dateOffset)] =
          Pair("${i + 1}", DateUtils.addDaysToDate(dayZeroOfMonth, (i + 1)));
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
