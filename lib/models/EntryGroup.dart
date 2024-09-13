// ignore_for_file: file_names

import 'package:hive/hive.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/services/DatabaseService.dart';

part "EntryGroup.g.dart";

@HiveType(typeId: 3)
class EntryGroup {
  @HiveField(0, defaultValue: "0001")
  String name;

  @HiveField(1, defaultValue: -1)
  int id;

  EntryGroup({required this.name, required this.id}) {
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
    return "EG$id";
  }

  static const String defaultId = "EG0001";

  List<DailyEntry> get sortedEntries => (DatabaseService.instance
          .getEntriesForGroup(generateId(id))
        ..sort(
            (element, other) => element.epochDate.compareTo(other.epochDate)))
      .toList();

  DailyEntry get first => sortedEntries.first;

  DailyEntry get last => sortedEntries.last;

  @override
  String toString() {
    return "EntryGroup: id $id, name $name";
  }
}
