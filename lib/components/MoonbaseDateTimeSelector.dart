// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/screens/EntryScreen.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseDateTimeSelector extends StatefulWidget {
  final int year;
  final int month;
  final int? day;

  const MoonbaseDateTimeSelector(
      {super.key, required this.year, required this.month, this.day});

  @override
  State<MoonbaseDateTimeSelector> createState() =>
      _MoonbaseDateTimeSelectorState();
}

class _MoonbaseDateTimeSelectorState extends State<MoonbaseDateTimeSelector> {
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController? dayController;
  late int year;
  late int month;
  late int? day;

  final DateFormat monthFormat = DateFormat("MMMM");

  @override
  void initState() {
    super.initState();
    yearController.text = "${widget.year}";
    monthController.text = "${widget.month}";
    year = widget.year;
    month = widget.month;
    day = widget.day;
    if (day != null) {
      dayController ??= TextEditingController();
      dayController?.text = "${widget.day}";
    }
  }

  DateTime buildDateTime({required int year, required int month, int? day}) {
    String leadingMonthZero = month < 10 ? "0" : "";
    day ??= 1;
    String leadingDayZero = day < 10 ? "0" : "";
    return DateTime.parse("$year-$leadingMonthZero$month-$leadingDayZero$day");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                      controller: yearController,
                      decoration: const InputDecoration(
                          hintText: "year",
                          constraints: BoxConstraints.tightFor(width: 70)),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (value) {
                        if (value.length == 4) {
                          setState(() {
                            year = int.parse(value);
                          });
                        }
                      }),
                  TextField(
                      controller: monthController,
                      decoration: const InputDecoration(
                          hintText: "month",
                          constraints: BoxConstraints.tightFor(width: 70)),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      onChanged: (value) {
                        int monthValue = int.parse(value);
                        if (value.length == 2 &&
                            (monthValue > 0 && monthValue <= 12)) {
                          setState(() {
                            month = monthValue;
                          });
                        }
                      }),
                  if (day != null)
                    TextField(
                        controller: dayController,
                        decoration: const InputDecoration(
                            hintText: "day",
                            constraints: BoxConstraints.tightFor(width: 70)),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          int dayValue = int.parse(value);
                          if (value.length == 2 &&
                              (dayValue > 0 &&
                                  dayValue <=
                                      DateUtils.getDaysInMonth(year, month))) {
                            setState(() {
                              day = dayValue;
                            });
                          }
                        }),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded,
                          color: Palette.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Palette.green[500]!,
                      ),
                      onPressed: () {
                        if (day == null) {
                          context
                              .pushNamed(CalendarScreen.name, pathParameters: {
                            "epochDate":
                                "${DateTimeUtils.epochDays(buildDateTime(year: year, month: month, day: day))}"
                          });
                        } else {
                          context.pushNamed(EntryScreen.name, pathParameters: {
                            "epochDate":
                                "${DateTimeUtils.epochDays(buildDateTime(year: year, month: month, day: day))}"
                          });
                        }
                      })
                ])));
  }
}
