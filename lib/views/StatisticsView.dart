// ignore_for_file: file_names

import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:tadpole/controllers/StatisticsController.dart';
import 'package:tadpole/helpers/LocalStorageState.dart';
import 'package:tadpole/models/EntryModel.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State createState() => _StatisticsViewState();
}

class _StatisticsViewState extends LocalStorageState<StatisticsView> {
  StatisticsController controller = StatisticsController();

  bool initialLoad = true;

  YearMetadata? lastYear;
  List<CycleMetadata>? cycles;

  int allTimeBleedingDaysTotal = 0;
  int allTimeFlowDaysTotal = 0;
  int allTimePainDaysTotal = 0;
  int allTimeDaysTotal = 1;
  int daysLastYear = 365;

  @override
  Future<void> loadLocalData() async {
    if (initialLoad) {
      cycles = await controller.getCycles();
      if (cycles != null) {
        allTimeDaysTotal = 0;
        lastYear = controller.getLastYear(cycles!);
        for (CycleMetadata element in cycles!) {
          allTimeBleedingDaysTotal += element.bleedingDaysCount;
          allTimeFlowDaysTotal += element.flowDaysCount ?? 0;
          allTimePainDaysTotal += element.painDaysCount ?? 0;
          allTimeDaysTotal += element.daysInCycle;
        }
        daysLastYear = min(365, allTimeDaysTotal);
      }

      initialLoad = false;
    }
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics View"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.lightGreen,
              ),
              child: Column(
                children: [
                  const Text(
                    "Over the last year...",
                  ),
                  Text(
                    "You've bled for ${lastYear?.bleedingDaysCount ?? 'unknown'} days (${(((lastYear?.bleedingDaysCount ?? 0) / daysLastYear) * 100).round()}%)",
                  ),
                  Text(
                    "You've had heavy flow for ${lastYear?.heavyFlowCount ?? 'unknown'} days (${(((lastYear?.heavyFlowCount ?? 0) / daysLastYear) * 100).round()}%)",
                  ),
                  Text(
                    "You've had major pain for ${lastYear?.majorPainCount ?? 'unknown'} days (${(((lastYear?.majorPainCount ?? 0) / daysLastYear) * 100).round()}%)",
                  ),
                  Text(
                    "Each cycle has lasted ${(lastYear?.cycleLength())?.round() ?? 'unknown'} days on average",
                  ),
                ],
              ),
            ),
            const Divider(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Column(
                children: [
                  const Text("Per cycle..."),
                  Text(
                      "You've bled ${(allTimeBleedingDaysTotal / (cycles?.length ?? 1)).round()} days (${((allTimeBleedingDaysTotal / allTimeDaysTotal) * 100).round()}%)"),
                  Text(
                      "You've had heavy flow for ${(allTimeFlowDaysTotal / (cycles?.length ?? 1)).round()} days on average (${((allTimeFlowDaysTotal / allTimeDaysTotal) * 100).round()}%)"),
                  Text(
                      "You've had major pain for ${(allTimePainDaysTotal / (cycles?.length ?? 1)).round()} days on average (${((allTimePainDaysTotal / allTimeDaysTotal) * 100).round()}%)"),
                ],
              ),
            ),
            const Divider(
              height: 10,
            ),
            ExpansionTile(
              title: const Text("View cycles..."),
              children: cycles?.map<ListTile>((element) {
                    return ListTile(
                      tileColor: Colors.lightBlue,
                      title: Text(
                          "Cycle ${element.cycleNumber}: ${element.daysInCycle} days"),
                      subtitle: Column(
                        children: [
                          Text(
                              "Bleeding Days: ${element.bleedingDaysCount} (${((element.bleedingDaysCount / element.daysInCycle) * 100).round()}%)"),
                          Text(
                              "Flow Days: ${element.flowDaysCount} (${((element.flowDaysCount ?? 0 / element.daysInCycle) * 100).round()}%)"),
                          Text(
                              "Pain Days: ${element.painDaysCount} (${((element.painDaysCount ?? 0 / element.daysInCycle) * 100).round()}%)"),
                        ],
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}
