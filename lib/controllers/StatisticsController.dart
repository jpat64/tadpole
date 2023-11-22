// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names, avoid_function_literals_in_foreach_calls
import 'package:decimal/decimal.dart';
import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/EntryModel.dart';

class StatisticsController extends BaseController {
  Future<List<CycleMetadata>> getCycles() async {
    List<Entry> entries = await storageService.getEntries();

    List<CycleMetadata> cycles = List<CycleMetadata>.empty(growable: true);
    int previousCycleNumber = -1;
    for (Entry entry in entries) {
      if (entry.cycle != previousCycleNumber) {
        cycles.add(CycleMetadata(
            firstDayOfCycle: entry.id,
            bleedingDaysCount: 0,
            cycleNumber: entry.cycle,
            daysInCycle: 1));
        previousCycleNumber = entry.cycle;
      } else {
        CycleMetadata lastCycle = cycles.last;
        lastCycle.daysInCycle += 1;
        if (entry.bleeding) {
          lastCycle.bleedingDaysCount += 1;
        }
        if ((entry.pain ?? 0) > 0) {
          lastCycle.painDaysCount = lastCycle.painDaysCount == null
              ? 1
              : lastCycle.painDaysCount! + 1;
        }
        if ((entry.flow ?? 0) > 0) {
          lastCycle.flowDaysCount = lastCycle.flowDaysCount == null
              ? 1
              : lastCycle.flowDaysCount! + 1;
        }
      }
    }
    return cycles;
  }

  YearMetadata getLastYear(List<CycleMetadata> cycles) {
    const int MILLIS_PER_DAY = 86400000;
    int newYearsDayNumber = Decimal.parse(
            "${DateTime.now().copyWith(month: 1, day: 1, second: 0, minute: 0, microsecond: 0, millisecond: 0).millisecondsSinceEpoch / MILLIS_PER_DAY}")
        .floor()
        .toBigInt()
        .toInt();

    List<CycleMetadata> cyclesThisYear = cycles
        .where((element) => element.firstDayOfCycle >= newYearsDayNumber)
        .toList();

    int bleedingDaysCount = 0;
    int flowDaysCount = 0;
    int painDaysCount = 0;
    for (CycleMetadata cycle in cyclesThisYear) {
      bleedingDaysCount += cycle.bleedingDaysCount;
      flowDaysCount += cycle.flowDaysCount ?? 0;
      painDaysCount += cycle.painDaysCount ?? 0;
    }

    YearMetadata yearMetadata = YearMetadata(
      bleedingDaysCount: bleedingDaysCount,
      cycles: cyclesThisYear,
      heavyFlowCount: flowDaysCount == 0 ? null : flowDaysCount,
      majorPainCount: painDaysCount == 0 ? null : painDaysCount,
    );
    return yearMetadata;
  }
}

class YearMetadata {
  // assume 'last year' refers to 365 days, since it's not within this calendar year, but just in the last 365 days
  static const int DAYS_IN_YEAR = 365;

  int bleedingDaysCount;
  int? heavyFlowCount;
  int? majorPainCount;
  List<CycleMetadata> cycles;

  YearMetadata({
    required this.bleedingDaysCount,
    this.heavyFlowCount,
    this.majorPainCount,
    required this.cycles,
  });

  double cycleLength() {
    int cyclesCount = cycles.length;
    int daysCount = 0;
    cycles.forEach((element) => daysCount += element.daysInCycle);
    return daysCount / cyclesCount;
  }
}

class CycleMetadata {
  int firstDayOfCycle;
  int daysInCycle;
  int cycleNumber;
  int bleedingDaysCount;
  int? flowDaysCount;
  int? painDaysCount;

  CycleMetadata({
    required this.firstDayOfCycle,
    required this.daysInCycle,
    required this.cycleNumber,
    required this.bleedingDaysCount,
    this.flowDaysCount,
    this.painDaysCount,
  });
}
