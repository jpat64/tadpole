// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Tuple.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarScreenState();

  static const String name = "/calendar";
}

class _CalendarScreenState extends State<CalendarScreen> {
  Column getCalendar(BuildContext context, DateTime dateTime) {
    DatabaseService instance = DatabaseService.instance();
    List<List<Tuple<String, DateTime>>> boxNames =
        DateTimeUtils.arrangeMonth(dateTime);
    return Column(
      children: boxNames.map<Row>((element) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: element.map<Widget>((subelement) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.125,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: (instance.isEntryActiveForDay(subelement.last))
                      ? const TextStyle(fontWeight: FontWeight.bold)
                      : null,
                  backgroundColor: (DateUtils.dateOnly(subelement.last) ==
                          DateUtils.dateOnly(DateTime.now()))
                      ? Colors.yellow
                      : Colors.white,
                ),
                onPressed: () {
                  print("${subelement.first} pressed");
                },
                child: Text(subelement.first),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: getCalendar(context, DateTime.now()),
      ),
    );
  }
}
