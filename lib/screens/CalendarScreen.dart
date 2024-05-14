// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/components/LoadingWidget.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/components/MoonbaseDayButton.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:moonbase/utils/data/Pair.dart';

import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.epochDate});

  final int epochDate;

  @override
  State<StatefulWidget> createState() => _CalendarScreenState();

  static const String name = "/calendar";
  static const int navIndex = 0;
  static int defaultEpochDate =
      DateTimeUtils.epochDays(DateUtils.addDaysToDate(DateTime.now(), 0));
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
  ListView getCalendar(BuildContext context, DateTime dateTime) {
    List<String> dayOfWeekNames = ["S", "M", "T", "W", "R", "F", "S"];
    List<List<Pair<String, DateTime>>> boxNames =
        DateTimeUtils.arrangeMonth(dateTime);
    return ListView(
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
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Palette.black, width: 2))),
                      child: Text(
                        element,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
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
                            activeColors:
                                Pair(Palette.tan[100]!, Palette.tan[500]!),
                            inactiveColors:
                                Pair(Palette.gray[100]!, Palette.gray[500]!),
                            data: subelement,
                          )
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: Palette.black),
                  onPressed: () {
                    if (relevantDateTime != null) {
                      DateTime lastMonth =
                          DateUtils.addMonthsToMonthDate(relevantDateTime!, -1);
                      lastMonth = DateUtils.addDaysToDate(lastMonth, 1);

                      context.pushNamed(CalendarScreen.name, pathParameters: {
                        "epochDate": "${DateTimeUtils.epochDays(lastMonth)}"
                      });
                    }
                  }),
              Text(monthYear.format(relevantDateTime!),
                  style: const TextStyle(fontFamily: "Freeman")),
              const Spacer(),
              IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Palette.black),
                  onPressed: () {
                    if (relevantDateTime != null) {
                      DateTime nextMonth =
                          DateUtils.addMonthsToMonthDate(relevantDateTime!, 1);
                      nextMonth = DateUtils.addDaysToDate(nextMonth, 1);
                      context.pushNamed(CalendarScreen.name, pathParameters: {
                        "epochDate": "${DateTimeUtils.epochDays(nextMonth)}"
                      });
                    }
                  })
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
