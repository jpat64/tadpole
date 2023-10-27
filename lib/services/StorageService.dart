// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadpole/models/EntryModel.dart';

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
  Future<List<String>?> getInputs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("tadpole_items");
  }

  // ADD because we don't support edit for MVP yet
  Future<bool> addEntry(Entry? entry) async {
    // step 0: null check & setup
    if (entry == null) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    bool hasSymptoms = entry.symptoms?.isNotEmpty ?? false;
    List<String> symptomsCompressed = hasSymptoms
        ? prefs.getStringList("tadpole_symptoms") ??
            List<String>.empty(growable: true)
        : List<String>.empty();
    List<String> entrySymptoms = hasSymptoms
        ? prefs.getStringList("tadpole_entry_symptoms") ??
            List<String>.empty(growable: true)
        : List<String>.empty();
    bool hasActivities = entry.activities?.isNotEmpty ?? false;
    List<String> activitiesCompressed = hasActivities
        ? prefs.getStringList("tadpole_activities") ??
            List<String>.empty(growable: true)
        : List<String>.empty();
    List<String> entryActivities = hasActivities
        ? prefs.getStringList("tadpole_entry_activities") ??
            List<String>.empty(growable: true)
        : List<String>.empty();

    // step 1: get all symptoms and add any new ones
    // step 1a: only store if there exist symptoms on entry
    if (hasSymptoms) {
      // step 1b: get symptoms list (as list of Symptoms)
      List<Symptom> symptomsDecompressed =
          symptomsCompressed.map<Symptom>((String element) {
        return Symptom.decompress(element);
      }).toList();

      // step 1c: for each symptom, store if its text is unique
      // LOGROLL: store the compressed version, too- it's not editable
      for (Symptom s in entry.symptoms!) {
        if (symptomsDecompressed.contains(s) == false) {
          symptomsDecompressed.add(s);
          symptomsCompressed.add(s.compress());
        }
      }

      // step 1d: add entry-symptoms (should all be new since we are ADDing)
      for (Symptom s in entry.symptoms!) {
        entrySymptoms
            .add("{\"entry_id\":\"${entry.id}\",\"symptom_id\":\"${s.id}\"}");
      }
    }

    // step 2: get all activities and add any new ones
    // step 2a: only add if there exist activities on entry
    if (hasActivities) {
      // step 2b: get activities list (as list of Activitys)
      List<Activity> activitiesDecompressed =
          activitiesCompressed.map<Activity>((String element) {
        return Activity.decompress(element);
      }).toList();

      // step 2c: for each activity, store if its text is unique
      // LOGROLL: store the compressed version, too- it's not editable
      for (Activity a in entry.activities!) {
        if (activitiesDecompressed.contains(a) == false) {
          activitiesDecompressed.add(a);
          activitiesCompressed.add(a.compress());
        }
      }

      // step 2d: add entry-activities (should all be new since we are ADDing)
      for (Activity a in entry.activities!) {
        entryActivities
            .add("{\"entry_id\":\"${entry.id}\",\"activity_id\":\"${a.id}\"}");
      }
    }

    // step 3: store compressed symptoms, compressed activities, entry-symptoms, entry-activities, and compressed entry
    // step 3a: compress Entry
    String entryCompressed = entry.compress();

    // step 3b: get Entry list as list of decompressed Entrys
    List<String> entriesCompressed = prefs.getStringList("tadpole_entries") ??
        List<String>.empty(growable: true);
    List<Entry> entriesDecompressed = entriesCompressed.map<Entry>((element) {
      return Entry.decompress(element);
    }).toList();

    // step 3c: ensure the entry isn't a duplicate
    if (entriesDecompressed.contains(entry) == false) {
      entriesCompressed.add(entryCompressed);
      entriesDecompressed.add(entry);
      try {
        // step 3d: store everything- entry, then symptoms, then entry-symptoms, then activities, then entry-activities
        prefs.setStringList("tadpole_entries", entriesCompressed);
        if (hasSymptoms) {
          prefs.setStringList("tadpole_symptoms", symptomsCompressed);
          prefs.setStringList("tadpole_entry_symptoms", entrySymptoms);
        }
        if (hasActivities) {
          prefs.setStringList("tadpole_activities", activitiesCompressed);
          prefs.setStringList("tadpole_entry_activities", entryActivities);
        }
        return true;
      } catch (e) {
        throw Exception("error saving new entry $entry: $e");
      }
    }
    return false;
  }

  Future<bool> storeInputs(List<String>? inputs) async {
    if (inputs == null) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setStringList("tadpole_items", inputs);
      return true;
    } catch (e) {
      throw Exception("ERROR: unable to save inputs $e");
    }
  }
}
