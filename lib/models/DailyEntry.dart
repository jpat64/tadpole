// ignore_for_file: file_names
import 'package:hive_flutter/hive_flutter.dart';

part 'DailyEntry.g.dart';

@HiveType(typeId: 0)
class DailyEntry {
  @HiveField(0)
  bool isActive;

  @HiveField(1)
  String? notes;

  @HiveField(2)
  int epochDate;

  DailyEntry({required this.isActive, this.notes, required this.epochDate});
}
