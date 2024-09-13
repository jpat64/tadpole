// ignore_for_file: file_names

import 'package:moonbase/models/DailyEntry.dart';

/// EntryGroup is a CONSTRUCTED class, made from lots of operations
/// performed on the existing set of DailyEntries. Because of this, we don't
/// have to deal with whatever inconsistencies a db might have, and instead,
/// we can guarantee that all the data is processed neatly
class EntryGroup implements Comparable {
  List<DailyEntry> sortedDailyEntries;

  String name;

  EntryGroup({required this.name, required this.sortedDailyEntries});

  @override
  int compareTo(dynamic other) {
    assert(other is EntryGroup, "EntryGroups can only compare to each other");
    return sortedDailyEntries.last
        .compareTo((other as EntryGroup).sortedDailyEntries.last);
  }

  @override
  String toString() {
    return "EntryGroup: name: $name entries: $sortedDailyEntries";
  }
}
