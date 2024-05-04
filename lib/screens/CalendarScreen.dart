// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/utils/arrangeMonth.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarScreenState();

  static const String name = "/calendar";
}

class _CalendarScreenState extends State<CalendarScreen> {
  Column getCalendar() {
    List<List<String>> boxNames = arrangeMonth(DateTime.now());
    return Column(
      children: boxNames.map<Row>((element) {
        return Row(
          children: element.map<TextButton>((subelement) {
            return TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    (subelement.contains("!")) ? Colors.yellow : Colors.white,
              ),
              onPressed: () {
                print("$subelement pressed");
              },
              child: Text(subelement.replaceAll("!", "")),
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
      body: getCalendar(),
    );
  }
}
