// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:collection';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/models/ThemeModel.dart';
import 'package:tadpole/helpers/Pair.dart';

/*
  "DB" Structure:
    Everything is stored in local storage, so that we don't have to talk to a server.
    Local storage should be device-agnostic, or at least something like that due to the shared preferences package.
    Therefore, the storage we use should look like this:
      A String List variable named "tadpole_entries"
      A String List variable named "tadpole_entries_symptoms"
      A String List variable named "tadpole_entries_activities"
      A String List variable named "tadpole_symptoms"
      A String List variable named "tadpole_activities"
    When we store a new Entry, Symptom, or Activity, we compress() it and then load the list object, add the compress()'d item to the list, then re-store it.
    When we store a new Entry-Symptom or Entry-Activity, we just store the json string
*/

class StorageService {
  static String SYMPTOMS = "tadpole_symptoms";
  static String ACTIVITIES = "tadpole_activities";
  static String ENTRIES = "tadpole_entries";
  static String ENTRY_SYMPTOMS = "tadpole_entries_symptoms";
  static String ENTRY_ACTIVITIES = "tadpole_entries_activities";
  static String NEXT_ENTRY_ID = "tadpole_next_entry_id";
  static String NEXT_SYMPTOM_ID = "tadpole_next_symptom_id";
  static String NEXT_ACTIVITY_ID = "tadpole_next_activity_id";
  static String NEXT_CYCLE_NUMBER = "tadpole_next_cycle_number";
  static String PREFERENCES = "tadpole_preferences";
  static String THEMES = "tadpole_themes";

  // helper method to one-line and un-null table results
  Future<List<String>> getTable(String tableName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(tableName) ?? List<String>.empty(growable: true);
  }

  // helper method to one-line and un-try/catch table sets
  Future<bool> setTable(String tableName, List<String> table) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setStringList(tableName, table);
      return true;
    } catch (e) {
      throw Exception("Error writing table $tableName: $e");
    }
  }

  Future<bool> setStoredInt(String variableName, int value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setInt(variableName, value);
      return true;
    } catch (e) {
      throw Exception("Error writing value $variableName: $e");
    }
  }

  Future<bool> setStoredString(String variableName, String value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString(variableName, value);
      return true;
    } catch (e) {
      throw Exception("Error writing value $variableName: $e");
    }
  }

  Future<int> getStoredInt(String variableName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(variableName) ?? 0;
  }

  Future<String> getStoredString(String variableName) async {
    final prefs = await SharedPreferences.getInstance();
    String strVariable = prefs.containsKey(variableName)
        ? prefs.getString(variableName) ?? ""
        : "";
    return strVariable;
  }

  Future<bool> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString(PREFERENCES, "");
      return true;
    } catch (e) {
      throw Exception('could not clear preferences: $e');
    }
  }

  Future<bool> clearThemes() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setStringList(THEMES, List<String>.empty(growable: true));
      return true;
    } catch (e) {
      throw Exception('could not clear themes: $e');
    }
  }

  Future<bool> clearEntries() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setStringList(ENTRIES, List<String>.empty(growable: true));
      prefs.setStringList(ENTRY_ACTIVITIES, List<String>.empty(growable: true));
      prefs.setStringList(ENTRY_SYMPTOMS, List<String>.empty(growable: true));
      return true;
    } catch (e) {
      throw Exception("could not clear Entries: $e");
    }
  }

  Future<Map<int, ThemeModel>> getThemes() async {
    List<String> rawThemes = await getTable(THEMES);
    return {
      for (var element in rawThemes.map<ThemeModel>((element) {
        Map<String, dynamic> elementJson = json.decode(element);
        return ThemeModel.fromJson(elementJson);
      }))
        (element).id: element
    };
  }

  Future<bool> setPreferences(PreferencesModel prefs) async {
    return await setStoredString(PREFERENCES, prefs.toJsonString());
  }

  Future<bool> addTheme(ThemeModel theme) async {
    Map<int, ThemeModel> themes = await getThemes();
    themes.putIfAbsent(theme.id, () => theme);
    return await setTable(
        THEMES,
        themes.values.map<String>((element) {
          return json.encode(element.toJson());
        }).toList());
  }

  // DELETE if exists, then CREATE (works to both update and add)
  Future<bool> updateEntry(Entry? entry) async {
    // step 0: null check & setup
    if (entry == null) {
      return false;
    }

    // step 1: remove if an entry with this ID already exists
    List<String> rawEntries = await getTable(ENTRIES);
    List<String> entrySymptoms = await getTable(ENTRY_SYMPTOMS);
    List<String> entryActivities = await getTable(ENTRY_ACTIVITIES);
    List<Entry> entries = rawEntries.map<Entry>((element) {
      return Entry.decompress(element);
    }).toList();

    int entryIndex = entries.indexOf(entry);
    if (entryIndex >= 0) {
      entries.removeAt(entryIndex);
      rawEntries.removeAt(entryIndex);
      int entryId = entry.id;
      entrySymptoms.removeWhere(
        (element) {
          Map<String, dynamic> jsonDecoded = json.decode(element);
          Pair<int, int> kvPair = Pair<int, int>(
            first: int.parse(jsonDecoded['entry_id']),
            last: int.parse(jsonDecoded['symptom_id']),
          );
          return kvPair.first == entryId;
        },
      );
      entryActivities.removeWhere(
        (element) {
          Map<String, dynamic> jsonDecoded = json.decode(element);
          Pair<int, int> kvPair = Pair<int, int>(
            first: int.parse(jsonDecoded['entry_id']),
            last: int.parse(jsonDecoded['activity_id']),
          );
          return kvPair.first == entryId;
        },
      );
    }

    bool hasSymptoms = entry.symptoms?.isNotEmpty ?? false;
    List<String> symptomsCompressed =
        hasSymptoms ? await getTable(SYMPTOMS) : List<String>.empty();
    bool hasActivities = entry.activities?.isNotEmpty ?? false;
    List<String> activitiesCompressed =
        hasActivities ? await getTable(ACTIVITIES) : List<String>.empty();

    // step 2: get all symptoms and add any new ones
    // step 2a: only store if there exist symptoms on entry
    if (hasSymptoms) {
      // step 2b: get symptoms list (as list of Symptoms)
      List<Symptom> symptomsDecompressed =
          symptomsCompressed.map<Symptom>((String element) {
        return Symptom.decompress(element);
      }).toList();

      // step 2c: for each symptom, store if its text is unique
      // LOGROLL: store the compressed version, too- it's not editable
      for (Symptom s in entry.symptoms!) {
        if (symptomsDecompressed.contains(s) == false) {
          symptomsDecompressed.add(s);
          symptomsCompressed.add(s.compress());
        }
      }

      // step 2d: add entry-symptoms (should all be new since we are ADDing)
      for (Symptom s in entry.symptoms!) {
        entrySymptoms
            .add("{\"entry_id\":\"${entry.id}\",\"symptom_id\":\"${s.id}\"}");
      }
    }

    // step 3: get all activities and add any new ones
    // step 3a: only add if there exist activities on entry
    if (hasActivities) {
      // step 3b: get activities list (as list of Activitys)
      List<Activity> activitiesDecompressed =
          activitiesCompressed.map<Activity>((String element) {
        return Activity.decompress(element);
      }).toList();

      // step 3c: for each activity, store if its text is unique
      // LOGROLL: store the compressed version, too- it's not editable
      for (Activity a in entry.activities!) {
        if (activitiesDecompressed.contains(a) == false) {
          activitiesDecompressed.add(a);
          activitiesCompressed.add(a.compress());
        }
      }

      // step 3d: add entry-activities (should all be new since we are ADDing)
      for (Activity a in entry.activities!) {
        entryActivities
            .add("{\"entry_id\":\"${entry.id}\",\"activity_id\":\"${a.id}\"}");
      }
    }

    // step 4: store compressed symptoms, compressed activities, entry-symptoms, entry-activities, and compressed entry
    // step 4a: compress Entry
    String entryCompressed = entry.compress();
    rawEntries.add(entryCompressed);
    entries.add(entry);

    try {
      // step 4d: store everything- entry, then symptoms, then entry-symptoms, then activities, then entry-activities
      bool success = true;
      success = success | await setTable(ENTRIES, rawEntries);
      success = success | await setTable(ENTRY_SYMPTOMS, entrySymptoms);
      success = success | await setTable(ENTRY_ACTIVITIES, entryActivities);
      if (hasSymptoms) {
        success = success | await setTable(SYMPTOMS, symptomsCompressed);
      }
      if (hasActivities) {
        success = success | await setTable(ACTIVITIES, activitiesCompressed);
      }
      return success;
    } catch (e) {
      throw Exception("error saving new entry $entry: $e");
    }
  }

  // READ all entries from local storage
  Future<List<Entry>> getEntries() async {
    List<String> compressedEntries = await getTable(ENTRIES);
    Map<int, Entry> entriesDecompressed =
        HashMap.fromIterable(compressedEntries.map<Entry>((element) {
      return Entry.decompress(element);
    }), key: (element) {
      return (element as Entry).id;
    }, value: (element) {
      return element as Entry;
    });

    List<String> compressedSymptoms = await getTable(SYMPTOMS);
    Map<int, Symptom> symptomsDecompressed =
        HashMap.fromIterable(compressedSymptoms.map<Symptom>((element) {
      return Symptom.decompress(element);
    }), key: (element) {
      return element.id;
    }, value: (element) {
      return element;
    });

    List<String> compressedActivities = await getTable(ACTIVITIES);
    Map<int, Activity> activitiesDecompressed =
        HashMap.fromIterable(compressedActivities.map<Activity>((element) {
      return Activity.decompress(element);
    }), key: (element) {
      return element.id;
    }, value: (element) {
      return element;
    });

    List<String> entrySymptomsJson = await getTable(ENTRY_SYMPTOMS);
    List<Pair<int, int>> entrySymptoms =
        entrySymptomsJson.map<Pair<int, int>>((element) {
      Map<String, dynamic> jsonDecoded = json.decode(element);
      return Pair<int, int>(
        first: int.parse(jsonDecoded['entry_id']),
        last: int.parse(jsonDecoded['symptom_id']),
      );
    }).toList();

    List<String> entryActivitiesJson = await getTable(ENTRY_ACTIVITIES);
    List<Pair<int, int>> entryActivities =
        entryActivitiesJson.map<Pair<int, int>>((element) {
      dynamic jsonDecoded = json.decode(element);
      return Pair<int, int>(
        first: int.parse(jsonDecoded['entry_id']),
        last: int.parse(jsonDecoded['activity_id']),
      );
    }).toList();

    for (Pair<int, int> entrySymptom in entrySymptoms) {
      Entry? entryWithSymptom = entriesDecompressed[entrySymptom.first];
      Symptom? symptomWithEntry = symptomsDecompressed[entrySymptom.last];
      if (entryWithSymptom == null || symptomWithEntry == null) {
        throw Exception(
            'ERROR: found entry-symptom without one or more of corresponding Entry or corresponding Symptom: $entrySymptom');
      }
      entryWithSymptom.symptoms ??= List<Symptom>.empty(growable: true);
      entryWithSymptom.symptoms!.add(symptomWithEntry);
      entriesDecompressed[entrySymptom.first] = entryWithSymptom;
    }

    for (Pair<int, int> entryActivity in entryActivities) {
      Entry? entryWithActivity = entriesDecompressed[entryActivity.first];
      Activity? activityWithEntry = activitiesDecompressed[entryActivity.last];
      if (entryWithActivity == null || activityWithEntry == null) {
        throw Exception(
            'ERROR: found entry-activity without one or more of corresponding Entry or corresponding Activity: $entryActivity');
      }
      entryWithActivity.activities ??= List<Activity>.empty(growable: true);
      entryWithActivity.activities!.add(activityWithEntry);
      entriesDecompressed[entryActivity.first] = entryWithActivity;
    }
    List<Entry> entriesList = entriesDecompressed.values.toList();
    entriesList.sort((e1, e2) => e1.id - e2.id);
    return entriesList;
  }

  Future<List<Symptom>> getSymptoms() async {
    List<String> rawSymptoms = await getTable(SYMPTOMS);
    return rawSymptoms.map<Symptom>((element) {
      return Symptom.decompress(element);
    }).toList();
  }

  Future<List<Activity>> getActivities() async {
    List<String> rawActivities = await getTable(ACTIVITIES);
    return rawActivities.map<Activity>((element) {
      return Activity.decompress(element);
    }).toList();
  }
}
