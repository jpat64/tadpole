// ignore_for_file: file_names

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/EntryModel.dart';

class HistoryController extends BaseController {
  Future<List<Entry>> getEntries() async {
    List<Entry> entries = await storageService.getEntries();
    return entries;
  }
}
