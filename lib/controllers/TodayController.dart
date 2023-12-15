// ignore_for_file: file_names, constant_identifier_names

import 'package:decimal/decimal.dart';
import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/services/StorageService.dart';

class TodayController extends BaseController {
  Future<bool> addEntry(
      bool bleeding,
      bool newCycle,
      int? painLevel,
      int? flowLevel,
      List<Symptom>? symptoms,
      List<Activity>? activities) async {
    int cycleNumber =
        await storageService.getStoredInt(StorageService.NEXT_CYCLE_NUMBER);
    if (newCycle) {
      cycleNumber += 1;
      var success = await storageService.setStoredInt(
          StorageService.NEXT_CYCLE_NUMBER, cycleNumber);
      if (!success) print("ERROR- unable to increment cycle number");
    }
    Entry entry = Entry(
      cycle: cycleNumber,
      id: getTodayId(),
      pain: painLevel,
      flow: flowLevel,
      bleeding: bleeding,
      symptoms: symptoms,
      activities: activities,
    );
    storageService.updateEntry(entry);
    return true;
  }

  Future<List<Entry>> getEntries() async {
    return storageService.getEntries();
  }

  int getTodayId() {
    const int MILLIS_PER_DAY = 86400000;
    return Decimal.parse(
            "${DateTime.now().millisecondsSinceEpoch / MILLIS_PER_DAY}")
        .floor()
        .toBigInt()
        .toInt();
  }

  Future<List<Symptom>> getSymptoms() async {
    return storageService.getSymptoms();
  }

  Future<List<Activity>> getActivities() async {
    return storageService.getActivities();
  }
}
