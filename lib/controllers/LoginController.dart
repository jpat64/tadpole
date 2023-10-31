// ignore_for_file: file_names

import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/services/StorageService.dart';

class LoginController {
  final StorageService storageService = StorageService();

  Future<PreferencesModel> getPreferences() async {
    String preferences =
        await storageService.getStoredString(StorageService.PREFERENCES);
    return PreferencesModel.fromJsonString(preferences);
  }
}
