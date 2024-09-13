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
  static const String MOONBASE_ENTRY_GROUPS = "moonbase_entry_groups";
  late final Box<DailyEntry> _dailyEntryBox;
  late final Box<DailyEntryTag> _dailyEntryTagBox;
  late final Box<StyleTheme> _styleThemeBox;
  late final Box<EntryGroup> _entryGroupBox;

  Future<void> openBoxes() async {
    /*                          :::: DEBUG ONLY ::::
     *
     *   I messed with the models so this needs to get run- resets all the info. :(
     * 
     *   only uncomment the below lines if you want to reset all the local info.
     */
    // await Hive.deleteBoxFromDisk(MOONBASE_DAILY_ENTRIES);
    // await Hive.deleteBoxFromDisk(MOONBASE_DAILY_ENTRY_TAGS);
    // await Hive.deleteBoxFromDisk(MOONBASE_ENTRY_GROUPS);

    _dailyEntryBox = await Hive.openBox<DailyEntry>(MOONBASE_DAILY_ENTRIES);
    _dailyEntryTagBox =
        await Hive.openBox<DailyEntryTag>(MOONBASE_DAILY_ENTRY_TAGS);
    _styleThemeBox = await Hive.openBox<StyleTheme>(MOONBASE_STYLETHEMES);
    _entryGroupBox = await Hive.openBox<EntryGroup>(MOONBASE_ENTRY_GROUPS,
        crashRecovery: false);
  }

  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      Logger.info("Initializing... started Hive!");

      Hive.registerAdapter(DailyEntryAdapter());
      Hive.registerAdapter(DailyEntryTagAdapter());
      Hive.registerAdapter(StyleThemeAdapter());
      Hive.registerAdapter(EntryGroupAdapter());

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
      Logger.info(
          "Number of EntryGroups: ${instance._entryGroupBox.values.length}");
    } catch (e) {
      Logger.warning("DatabaseService.initialize() error ${e.toString()}");
    }
  }

  Future<bool> deleteDataFromBoxes() async {
    await _dailyEntryBox.clear();
    await _dailyEntryTagBox.clear();
    await _styleThemeBox.clear();
    await _entryGroupBox.clear();
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
      entryGroupId: extEntry.entryGroupId,
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

  //////// ENTRY GROUPS
  List<EntryGroup> get entryGroups => _entryGroupBox.values.toList();

  EntryGroup? getEntryGroupById(String id) => _entryGroupBox.get(id);

  EntryGroup? getEntryGroupByName(String name) => _entryGroupBox.values
      .where((element) => element.name == name)
      .firstOrNull;

  List<DailyEntry> getEntriesForGroup(String id) => _dailyEntryBox.values
      .where((element) => element.entryGroupId == id)
      .toList();

  Future<bool> addEntryGroup(EntryGroup group) async {
    try {
      await _entryGroupBox.put(EntryGroup.generateId(group.id), group);
      return true;
    } catch (e) {
      Logger.warning(e.toString());
      return false;
    }
  }

  List<EntryGroup> get _sortedEntryGroups => (_entryGroupBox.values.toList()
    ..sort(
      (element, other) =>
          element.last.epochDate.compareTo(other.last.epochDate),
    ));

  EntryGroup get mostRecentEntryGroup {
    if (_entryGroupBox.values.isEmpty) {
      return EntryGroup(id: -1, name: EntryGroup.defaultId);
    } else {
      return _sortedEntryGroups.last;
    }
  }

  EntryGroup? getPreviousEntryGroup(EntryGroup group) {
    int index =
        _sortedEntryGroups.indexWhere((element) => element.id == group.id);
    if (index - 1 >= 0) {
      return _sortedEntryGroups[index - 1];
    }
    return null;
  }

  EntryGroup? getNextEntryGroup(EntryGroup group) {
    int index =
        _sortedEntryGroups.indexWhere((element) => element.id == group.id);
    if (index + 1 < _sortedEntryGroups.length) {
      return _sortedEntryGroups[index + 1];
    }
    return null;
  }

  Future<bool> deleteEntryGroup(EntryGroup group) async {
    List<DailyEntry> abandonedEntries =
        getEntriesForGroup(EntryGroup.generateId(group.id));
    EntryGroup destinationGroup = getPreviousEntryGroup(group) ??
        getNextEntryGroup(group) ??
        EntryGroup(id: -1, name: EntryGroup.defaultId);

    try {
      bool success = true;
      for (DailyEntry abandonedEntry in abandonedEntries) {
        abandonedEntry.entryGroupId =
            EntryGroup.generateId(destinationGroup.id);
        success = success || await instance.addDailyEntry(abandonedEntry);
      }
      await _entryGroupBox.delete(EntryGroup.generateId(group.id));
      return success;
    } catch (e) {
      Logger.warning(e.toString());
      return false;
    }
  }
}
