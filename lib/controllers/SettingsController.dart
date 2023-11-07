// ignore_for_file: file_names

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/models/ThemeModel.dart';

class SettingsController extends BaseController {
  Future<bool> clearEntries() async {
    return await storageService.clearEntries();
  }

  Future<bool> clearPreferences() async {
    return await storageService.clearPreferences();
  }

  Future<Map<int, ThemeModel>> getAvailableThemes() async {
    return await storageService.getThemes();
  }

  Future<bool> updatePreferences(PreferencesModel prefs) async {
    return await storageService.setPreferences(prefs);
  }
}
