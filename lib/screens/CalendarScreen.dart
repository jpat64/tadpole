// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  Palette? palette;

  DateFormat monthYear = DateFormat("MMMM yyyy");

  @override
  void initState() {
    super.initState();
    relevantDateTime = DateTimeUtils.dateFromEpochDays(widget.epochDate);
  }

  // WIDGET HELPER METHOD
  ListView getCalendar(
      BuildContext context, BoxConstraints constraints, DateTime dateTime) {
    List<String> dayOfWeekNames = ["S", "M", "T", "W", "R", "F", "S"];
    List<List<Pair<String, DateTime>>> boxNames =
        DateTimeUtils.arrangeMonth(dateTime);
    return ListView(
      children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: dayOfWeekNames.map<Widget>((element) {
                  return SizedBox(
                    height: constraints.biggest.height * 0.03,
                    width: constraints.biggest.width * 0.125,
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
            Divider(
              thickness: 3,
              color: palette?.text ?? Palette.basic.text,
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
                    height: constraints.biggest.height * 0.125,
                    width: constraints.biggest.width * 0.125,
                    child: (subelement.first != "--")
                        ? MoonbaseDayButton(
                            palette: palette ?? Palette.basic,
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
    SchedulerBinding.instance.addPostFrameCallback((timestamp) async {
      if (palette == null) {
        Palette foundPalette = await Palette.currentPalette;
        setState(() {
          palette = foundPalette;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: palette?.iconTheme,
        backgroundColor: palette?.background,
        titleTextStyle: palette?.titleTextTheme,
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded,
                      color: palette?.text ?? Palette.basic.text),
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
                  icon: Icon(Icons.arrow_forward_ios_rounded,
                      color: palette?.text ?? Palette.basic.text),
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
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          color: palette?.background ?? Palette.basic.background,
          padding: const EdgeInsets.all(16),
          child: relevantDateTime != null
              ? getCalendar(
                  context,
                  constraints,
                  relevantDateTime!,
                )
              : const LoadingWidget(),
        ),
      ),
      bottomNavigationBar: MoonbaseBottomBar(
          palette: palette ?? Palette.basic,
          selectedIndex: CalendarScreen.navIndex),
    );
  }
}
