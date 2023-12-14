// ignore_for_file: file_names

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/EntryModel.dart';

class ForecastController extends BaseController {
  Future<List<Entry>> entriesFromThisCycle() async {
    List<Entry> entries = await storageService.getEntries();
    entries.sort((e1, e2) => e1.id - e2.id); // highest id is first
    int currentCycle = entries.firstOrNull?.cycle ?? 0;
    return entries.where((entry) => entry.cycle == currentCycle).toList();
  }
}
