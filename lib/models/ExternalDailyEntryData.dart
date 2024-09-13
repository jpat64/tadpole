// ignore_for_file: file_names

import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';

class ExternalDailyEntryData {
  final int epochDate;
  final bool secured;
  final int current;
  final int points;
  final int pallor;
  final String notes;
  final List<String> tags;
  final String entryGroupName;

  const ExternalDailyEntryData({
    required this.epochDate,
    required this.secured,
    required this.current,
    required this.points,
    required this.pallor,
    required this.notes,
    required this.tags,
    required this.entryGroupName,
  });

  ExternalDailyEntryData.fromDailyEntry({required DailyEntry entry})
      : epochDate = entry.epochDate,
        secured = (entry.secured ?? false),
        current = entry.current,
        points = entry.points,
        pallor = entry.pallor,
        notes = (entry.notes?.isNotEmpty ?? false) ? entry.notes! : "--",
        tags = (entry.tags?.isNotEmpty ?? false)
            ? entry.tags!.map<String>((element) => element.text).toList()
            : <String>["--"],
        entryGroupName = entry.entryGroupName;

  /// Expected CSV format:
  /// "<yyyy-mm-dd>,<Taken/Not Taken>,<current>,<points>,<pallor>,<notes with comma parse>,<tag texts as || separated list>,<entryGroupName>"
  /// "[0 - epochDate],[1 - secured],[2 - current],[3 - points],[4 - pallor],[5 - notes],[6 - tags],[7 - entryGroupName]"
  ExternalDailyEntryData.fromCsv({required String csvString})
      : epochDate = DateTimeUtils.epochDaysFromString(csvString.split(",")[0]),
        secured = csvString.split(",")[1] == "Taken" ? true : false,
        current = int.parse(csvString.split(",")[2]),
        points = int.parse(csvString.split(",")[3]),
        pallor = int.parse(csvString.split(",")[4]),
        notes = csvString
            .split(",")[5]
            .replaceAll("-comma-", ',')
            .replaceAll("\n", "-line-"),
        tags = csvString
            .split(",")[6]
            .split("||")
            .map<String>((element) =>
                element.replaceAll("-comma-", ',').replaceAll("\n", "-line-"))
            .toList(),
        entryGroupName = csvString.split(",").length > 7
            ? csvString.split(",")[7]
            : DailyEntry.defaultEntryGroupName;

  String toCsv() {
    return "${DateTimeUtils.stringFromEpochDays(epochDate)},${secured ? "Taken" : "Not Taken"},$current,$points,$pallor,${notes.replaceAll(",", "-comma-").replaceAll("-line-", "\n")},${tags.map<String>((element) => element.replaceAll(",", "-comma-").replaceAll("-line-", "\n")).join("||")},$entryGroupName";
  }
}
