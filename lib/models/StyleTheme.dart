// ignore_for_file: file_names

import 'package:hive/hive.dart';
import 'package:moonbase/utils/StringSum.dart';

part 'StyleTheme.g.dart';

@HiveType(typeId: 2)
class StyleTheme {
  @HiveField(0)
  bool unlocked;
  @HiveField(1)
  String paletteName;

  StyleTheme({required this.unlocked, required this.paletteName});

  static String generateId(String paletteName) {
    int textSum = StringSum.sumString(paletteName);
    return "ST$textSum";
  }

  @override
  String toString() {
    return "StyleTheme: $paletteName ($unlocked)";
  }
}
