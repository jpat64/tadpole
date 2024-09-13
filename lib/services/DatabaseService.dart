// ignore_for_file: file_names, constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/models/DailyEntryTag.dart';
import 'package:moonbase/models/EntryGroup.dart';
import 'package:moonbase/models/ExternalDailyEntryData.dart';
import 'package:moonbase/models/StyleTheme.dart';
import 'package:moonbase/services/Logger.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService();

  static DatabaseService get instance => _instance;

  static const String MOONBASE_DAILY_ENTRIES = "moonbase_daily_entries";
  static const String MOONBASE_DAILY_ENTRY_TAGS = "moonbase_daily_entry_tags";
  static const String MOONBASE_STYLETHEMES = "moonbase_stylethemes";
  late final Box<DailyEntry> _dailyEntryBox;
  late final Box<DailyEntryTag> _dailyEntryTagBox;
  late final Box<StyleTheme> _styleThemeBox;

  Future<void> openBoxes() async {
    /*                          :::: DEBUG ONLY ::::
     *
     *   I messed with the models so this needs to get run- resets all the info. :(
     * 
     *   only uncomment the below lines if you want to reset all the local info.
     */
    // await Hive.deleteBoxFromDisk(MOONBASE_DAILY_ENTRIES);
    // await Hive.deleteBoxFromDisk(MOONBASE_DAILY_ENTRY_TAGS);

    _dailyEntryBox = await Hive.openBox<DailyEntry>(MOONBASE_DAILY_ENTRIES);
    _dailyEntryTagBox =
        await Hive.openBox<DailyEntryTag>(MOONBASE_DAILY_ENTRY_TAGS);
    _styleThemeBox = await Hive.openBox<StyleTheme>(MOONBASE_STYLETHEMES);
  }

  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      Logger.info("Initializing... started Hive!");

      Hive.registerAdapter(DailyEntryAdapter());
      Hive.registerAdapter(DailyEntryTagAdapter());
      Hive.registerAdapter(StyleThemeAdapter());

      Logger.info("Initializing... adapters registered!");

      try {
        await DatabaseService.instance.openBoxes();
      } catch (e) {
        Logger.warning(
            "DatabaseService.instance.openBoxes() error opening boxes - $e");
        rethrow;
      }
      Logger.info("Initializing... boxes opened! Box information:");

      Logger.info(
          "Number of Daily Entries: ${instance._dailyEntryBox.values.length}");
      Logger.info(
          "Number of DailyEntry Tags: ${instance._dailyEntryTagBox.values.length}");
      Logger.info(
          "Number of StyleThemes: ${instance._styleThemeBox.values.length}");
    } catch (e) {
      Logger.warning("DatabaseService.initialize() error ${e.toString()}");
    }
  }

  Future<bool> deleteDataFromBoxes() async {
    await _dailyEntryBox.clear();
    await _dailyEntryTagBox.clear();
    await _styleThemeBox.clear();
    return true;
  }

  ///////// IMPORT/EXPORT ENTRIES AND TAGS

  List<String> getLinesForExport() {
    List<DailyEntry> entries = _dailyEntryBox.values.toList();

    List<String> entriesAsCsvs = [];
    for (DailyEntry entry in entries) {
      ExternalDailyEntryData external =
          ExternalDailyEntryData.fromDailyEntry(entry: entry);
      entriesAsCsvs.add(external.toCsv());
    }

    return entriesAsCsvs;
  }

  Future<bool> processExternalEntry(ExternalDailyEntryData extEntry) async {
    Logger.info("processExternalEntry ${extEntry.epochDate}");

    // for tag in tags:
    // see if tag exists,
    // if tag does not exist, make it
    List<DailyEntryTag> entryTags = _dailyEntryTagBox.values.toList();
    List<String> newTags = <String>[];
    List<String>? extEntryTags =
        extEntry.tags[0] == "--" ? null : extEntry.tags;
    for (String tagText in extEntryTags ?? []) {
      if (entryTags.where((element) => element.text == tagText).isEmpty &&
          (false == newTags.contains(tagText))) {
        newTags.add(tagText);
      }
    }
    Logger.info("external data processing: adding tags $newTags");
    bool success = await addTags(newTags);
    entryTags = _dailyEntryTagBox.values.toList();

    // then, make DailyEntry with tags
    // addDailyEntry with DailyEntry
    DailyEntry entry = DailyEntry(
      current: extEntry.current,
      points: extEntry.points,
      pallor: extEntry.pallor,
      epochDate: extEntry.epochDate,
      notes: extEntry.notes == "--" ? null : extEntry.notes,
      tags: extEntryTags?.map((element) => searchTags(element)[0]).toList(),
      secured: extEntry.secured,
      entryGroupName: extEntry.entryGroupName,
    );
    Logger.info("external data processing: adding daily entry $entry");
    success = await addDailyEntry(entry);
    return success;
  }

  ///////// DAILY ENTRIES

  bool existsEntryForDay(int epochDate) =>
      _dailyEntryBox.get(DailyEntry.generateId(epochDate)) != null;

  DailyEntry? getDailyEntry(int epochDate) =>
      _dailyEntryBox.get(DailyEntry.generateId(epochDate));

  DailyEntry? getDailyEntryById(String entryId) => _dailyEntryBox.get(entryId);

  Iterable<DailyEntry> get dailyEntries => _dailyEntryBox.values;

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

  List<EntryGroup> get sortedEntryGroups {
    List<EntryGroup> allEntryGroups = <EntryGroup>[];
    for (DailyEntry entry in _dailyEntryBox.values) {
      EntryGroup? existingEntryGroup = allEntryGroups
          .where((element) => element.name == entry.entryGroupName)
          .firstOrNull;
      if (existingEntryGroup != null) {
        existingEntryGroup.sortedDailyEntries.add(entry);
        existingEntryGroup.sortedDailyEntries.sort();
      } else {
        existingEntryGroup =
            EntryGroup(name: entry.entryGroupName, sortedDailyEntries: [entry]);
        allEntryGroups.add(existingEntryGroup);
      }
    }
    allEntryGroups.sort();
    return allEntryGroups;
  }

  EntryGroup? getPreviousEntryGroup(EntryGroup group) {
    int index =
        sortedEntryGroups.indexWhere((element) => element.name == group.name);
    if (index - 1 >= 0) {
      return sortedEntryGroups[index - 1];
    }
    return null;
  }

  EntryGroup? getNextEntryGroup(EntryGroup group) {
    int index =
        sortedEntryGroups.indexWhere((element) => element.name == group.name);
    if (index + 1 < sortedEntryGroups.length) {
      return sortedEntryGroups[index + 1];
    }
    return null;
  }

  bool isEntryFirstInGroup(DailyEntry entry) => (sortedEntryGroups
      .where((element) =>
          element.sortedDailyEntries.first.epochDate == entry.epochDate)
      .isNotEmpty);

  Future<bool> deleteEntryGroup(EntryGroup group) async {
    String newGroupName = getPreviousEntryGroup(group)?.name ??
        getNextEntryGroup(group)?.name ??
        DailyEntry.defaultEntryGroupName;
    try {
      bool success = true;
      for (DailyEntry affectedEntry in group.sortedDailyEntries) {
        affectedEntry.entryGroupName = newGroupName;
        success = success || await addDailyEntry(affectedEntry);
      }
      return success;
    } catch (e) {
      Logger.warning(
          "DatabaseService deleteEntryGroup failed for group $group");
      return false;
    }
  }

  //////// DAILY ENTRY TAGS

  List<DailyEntryTag> searchTags(String searchTerm) {
    List<DailyEntryTag> tags = _dailyEntryTagBox.values.toList();
    List<DailyEntryTag> startsWith =
        tags.where((element) => element.text.startsWith(searchTerm)).toList();
    List<DailyEntryTag> contains = tags
        .where(
          (element) =>
              (startsWith
                      .map<String>((subelement) => subelement.id)
                      .contains(element.id) ==
                  false) &&
              element.text.contains(searchTerm),
        )
        .toList();
    return startsWith + contains;
  }

  List<DailyEntryTag> searchTagsExact(String searchTerm) =>
      _dailyEntryTagBox.values
          .where((element) => element.text == searchTerm)
          .toList();

  Future<int> trimTags() async {
    int tagsTrimmed = 0;
    List<DailyEntryTag> tags = _dailyEntryTagBox.values.toList();
    for (DailyEntryTag tag in tags) {
      List<DailyEntryTag> duplicateTags = _dailyEntryTagBox.values
          .where((element) => element.text == tag.text && element.id != tag.id)
          .toList();
      for (DailyEntryTag duplicateTag in duplicateTags) {
        Logger.info(
            "duplicate tag found, deleting: $duplicateTag (duplicate of $tag)");
        _dailyEntryTagBox.delete(duplicateTag.id);
        tagsTrimmed += 1;
      }
    }
    return tagsTrimmed;
  }

  Future<bool> addTags(List<String> tagTexts) async {
    try {
      for (String text in tagTexts) {
        if (searchTagsExact(text).isEmpty) {
          String id = DailyEntryTag.generateId(text);
          Logger.info("addTags() adding tag $text ($id)");
          await _dailyEntryTagBox.put(id, DailyEntryTag(id: id, text: text));
        } else {
          Logger.info("addTags() tag $text already exists, skipping...");
        }
      }

      return true;
    } catch (e) {
      Logger.warning("addTags() exception: $e");
      return false;
    }
  }

  //////// STYLE THEMES

  List<StyleTheme> get themes => _styleThemeBox.values.toList();

  StyleTheme? getTheme(String name) => _styleThemeBox.values
      .where(
          (element) => element.paletteName.toLowerCase() == name.toLowerCase())
      .firstOrNull;

  bool isUnlocked(String name) => (_styleThemeBox.values
              .where((element) =>
                  element.paletteName.toLowerCase() == name.toLowerCase())
              .firstOrNull ??
          StyleTheme(paletteName: "unknown", unlocked: false))
      .unlocked;

  Future<bool> addTheme(StyleTheme theme) async {
    try {
      Logger.info("addTheme() adding theme $theme");
      String styleThemeId = StyleTheme.generateId(theme.paletteName);
      if (_styleThemeBox.get(styleThemeId) == null) {
        await _styleThemeBox.put(styleThemeId, theme);
        return true;
      } else {
        Logger.warning(
            "addTheme() StyleTheme with this name already exists: ${theme.paletteName}");
      }
    } catch (e) {
      Logger.warning("addTheme() error with theme $theme");
    }
    return false;
  }

  Future<bool> _setThemeLock(String name, bool unlocked) async {
    try {
      Logger.info("_setThemeLock() attempt: set $name => $unlocked");
      String styleThemeId = StyleTheme.generateId(name);
      if (_styleThemeBox.get(styleThemeId) != null) {
        await _styleThemeBox.put(
            styleThemeId, StyleTheme(paletteName: name, unlocked: unlocked));
        return true;
      } else {
        Logger.warning(
            "_setThemeLock() could not find theme with this name: $name");
      }
    } catch (e) {
      Logger.warning(
          "_setThemeLock() error with name: $name and unlocked: $unlocked");
    }
    return false;
  }

  Future<bool> unlockTheme(String name) async =>
      await _setThemeLock(name, true);

  Future<bool> lockTheme(String name) async => await _setThemeLock(name, false);
}
