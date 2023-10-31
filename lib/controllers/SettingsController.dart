// ignore_for_file: file_names

import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/services/StorageService.dart';

class SettingsController {
  final StorageService storageService = StorageService();

  Future<bool> clearEntries() async {
    return await storageService.clearEntries();
  }
}
