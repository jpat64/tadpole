// ignore_for_file: file_names

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/services/StorageService.dart';

class TodayController extends BaseController {
  // probably not necessary in the TodayController- could be moved to a controller for History, Forecast, and Statistics, when applicable
  List<Entry>? entries;
  List<Symptom>? symptoms;
  List<Activity>? activities;

  Future<bool> addEntry(bool bleeding) async {
    Entry entry = Entry(
      date: DateTime.now().copyWith(
          hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
      cycle:
          await storageService.getStoredInt(StorageService.NEXT_CYCLE_NUMBER),
      id: await storageService.getStoredInt(StorageService.NEXT_ENTRY_ID),
      bleeding: bleeding,
    );
    storageService.addEntry(entry);
    return true;
  }

  Future<List<Entry>> getEntries() async {
    return storageService.getEntries();
  }
}
