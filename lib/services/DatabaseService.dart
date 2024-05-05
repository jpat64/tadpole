// ignore_for_file: file_names, constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService();

  static DatabaseService instance() => _instance;

  static const String MOONBASE_DAILY_ENTRIES = "moonbase_daily_entries";
  late final Box<DailyEntry> _dailyEntryBox;

  Future<void> openBoxes() async {
    _dailyEntryBox = await Hive.openBox(MOONBASE_DAILY_ENTRIES);
  }

  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      Hive.registerAdapter(DailyEntryAdapter());

      DatabaseService instance = DatabaseService.instance();

      await instance.openBoxes();
      Logger.info(
          "Hive Instance Started. Number of Daily Entries: ${instance._dailyEntryBox.values.length}");
    } catch (e) {
      Logger.warning(e.toString());
    }
  }

  bool isEntryActiveForDay(DateTime dateTime) {
    int epochDays = DateTimeUtils.epochDays(dateTime);
    return _dailyEntryBox.get("E$epochDays") != null;
  }

  Future<bool> addDailyEntry(DailyEntry entry) async {
    try {
      await _dailyEntryBox.put(entry.epochDate, entry);
      return true;
    } catch (e) {
      Logger.warning(e.toString());
      return false;
    }
  }
}
