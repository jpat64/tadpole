// ignore_for_file: file_names, constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/services/Logger.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService();

  static DatabaseService instance() => _instance;

  static const String MOONBASE_DAILY_ENTRIES = "moonbase_daily_entries";
  late final Box<DailyEntry> _dailyEntryBox;

  Future<void> openBoxes() async {
    /*                          :::: DEBUG ONLY ::::
     *
     *   I messed with the models so this needs to get run- resets all the info. :(
     * 
     *   only uncomment the below line if you want to reset all the local info.
     */
    // await Hive.deleteBoxFromDisk(MOONBASE_DAILY_ENTRIES);

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

  bool existsEntryForDay(int epochDate) {
    return _dailyEntryBox.get(DailyEntry.generateId(epochDate)) != null;
  }

  DailyEntry? getDailyEntry(int epochDate) {
    return _dailyEntryBox.get(DailyEntry.generateId(epochDate));
  }

  Future<bool> addDailyEntry(DailyEntry entry) async {
    try {
      await _dailyEntryBox.put(entry.id, entry);
      return true;
    } catch (e) {
      Logger.warning(e.toString());
      return false;
    }
  }

  Future<bool> removeDailyEntry(String id) async {
    try {
      await _dailyEntryBox.delete(id);
      return true;
    } catch (e) {
      Logger.warning(e.toString());
      return false;
    }
  }
}
