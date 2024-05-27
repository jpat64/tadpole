// ignore_for_file: file_names
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moonbase/models/DailyEntryTag.dart';

part 'DailyEntry.g.dart';

@HiveType(typeId: 0)
class DailyEntry {
  @HiveField(0)
  String? notes;

  @HiveField(1)
  int epochDate;

  @HiveField(2)
  int current;

  @HiveField(3)
  int points;

  @HiveField(4)
  int pallor;

  @HiveField(5)
  List<DailyEntryTag>? tags;

  @HiveField(6)
  bool? secured;

  DailyEntry({
    this.notes,
    required this.epochDate,
    required this.current,
    required this.points,
    required this.pallor,
    this.tags,
    this.secured,
  });

  String get id => "E$epochDate";

  static String generateId(int epochDate) {
    return "E$epochDate";
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "epochDate": epochDate,
        "notes": "\"$notes\"",
        "current": current,
        "points": points,
        "pallor": pallor,
        "secured": secured,
        "tags": tags
                ?.map<Map<String, dynamic>>((element) => element.toJson())
                .toList() ??
            [],
      };

  @override
  String toString() {
    return "DailyEntry: epochDate:$epochDate current:$current points:$points pallor:$pallor tags:$tags notes:$notes secured:$secured";
  }
}
