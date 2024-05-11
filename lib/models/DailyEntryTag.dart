// ignore_for_file: file_names
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moonbase/utils/StringSum.dart';

part 'DailyEntryTag.g.dart';

@HiveType(typeId: 1)
class DailyEntryTag {
  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  DailyEntryTag({required this.id, required this.text});

  static String generateId(String text) {
    int textSum = StringSum.sumString(text);
    return "ET$textSum${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}";
  }
}
