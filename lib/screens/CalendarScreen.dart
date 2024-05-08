// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/components/LoadingWidget.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/components/MoonbaseDayButton.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:moonbase/utils/data/Triple.dart';
import 'package:moonbase/utils/data/Tuple.dart';

import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.epochDate});

  final int epochDate;

  @override
  State<StatefulWidget> createState() => _CalendarScreenState();

  static const String name = "/calendar";
  static const int navIndex = 0;
  static int defaultEpochDate = DateTimeUtils.epochDays(DateTime.now());
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? relevantDateTime;

  DateFormat monthYear = DateFormat("MMMM yyyy");

  @override
  void initState() {
    super.initState();
    relevantDateTime = DateTimeUtils.dateFromEpochDays(widget.epochDate);
  }

  // WIDGET HELPER METHOD
  Column getCalendar(BuildContext context, DateTime dateTime) {
    DatabaseService instance = DatabaseService.instance();
    List<String> dayOfWeekNames = ["S", "M", "T", "W", "R", "F", "S"];
    List<List<Tuple<String, DateTime>>> boxNames =
        DateTimeUtils.arrangeMonth(dateTime);
    return Column(
      children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).colorScheme.background,
                          width: 3))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: dayOfWeekNames.map<Widget>((element) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                    width: MediaQuery.of(context).size.width * 0.125,
                    child: Text(
                      element,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
          ] +
          boxNames.map<Widget>((element) {
            return Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: element.map<Widget>((subelement) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.125,
                    child: (subelement.first != "--")
                        ? MoonbaseDayButton(
                            textColor: Palette.black,
                            backgroundColor: Palette.gray[100]!,
                            hoverColor: Palette.gray[200]!,
                            data: Triple(
                                subelement.first,
                                subelement.last,
                                instance.getDailyEntryActivity(
                                    DateTimeUtils.epochDays(subelement.last))))
                        : null,
                  );
                }).toList(),
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthYear.format(relevantDateTime!),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: relevantDateTime != null
            ? getCalendar(
                context,
                relevantDateTime!,
              )
            : const LoadingWidget(),
      ),
      bottomNavigationBar:
          const MoonbaseBottomBar(selectedIndex: CalendarScreen.navIndex),
    );
  }
}
