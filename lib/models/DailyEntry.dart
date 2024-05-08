// ignore_for_file: file_names
import 'package:hive_flutter/hive_flutter.dart';

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

  DailyEntry(
      {this.notes,
      required this.epochDate,
      required this.current,
      required this.points,
      required this.pallor});

  String get id => "E$epochDate";

  static String generateId(int epochDate) {
    return "E$epochDate";
  }
}
