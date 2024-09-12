// ignore_for_file: file_names

import 'package:hive/hive.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/services/DatabaseService.dart';

part "EntryGroup.g.dart";

@HiveType(typeId: 3)
class EntryGroup {
  @HiveField(0, defaultValue: "0001")
  String name;

  @HiveField(1, defaultValue: <DailyEntry>[])
  List<DailyEntry> entries;

  @HiveField(2, defaultValue: -1)
  late int id;

  EntryGroup({required this.name, required this.entries}) {
    List<EntryGroup> entryGroups = DatabaseService.instance.entryGroups;
    while (entryGroups
        .map<int>((element) => element.id)
        .contains(entryGroupsCount)) {
      entryGroupsCount += 1;
    }
    id = entryGroupsCount;
  }

  static int entryGroupsCount = 0;

  static String generateId(int id) {
    return "EG-$id";
  }

  static const String defaultId = "EG-0001";

  // what an awesome one-liner
  List<int> get _sortedEpochDates => entries.isNotEmpty
      ? (entries.map<int>((element) => element.epochDate).toList()..sort())
      : [0];

  int get highestEpochDate => _sortedEpochDates.last;

  int get lowestEpochDate => _sortedEpochDates.first;

  @override
  String toString() {
    return "EntryGroup: id $id, name $name, entries [$entries]";
  }
}
