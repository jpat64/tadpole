// ignore_for_file: file_names

import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/models/ThemeModel.dart';
import 'package:tadpole/services/StorageService.dart';

class BaseController {
  final StorageService storageService = StorageService();

  Future<PreferencesModel> getPreferences() async {
    String preferences =
        await storageService.getStoredString(StorageService.PREFERENCES);
    return PreferencesModel.fromJsonString(preferences);
  }

  Future<ThemeModel> getTheme(int themeId) async {
    Map<int, ThemeModel> themes = await storageService.getThemes();
    return themes[themeId] ?? ThemeModel.base();
  }
}
