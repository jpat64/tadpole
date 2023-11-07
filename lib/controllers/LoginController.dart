// ignore_for_file: file_names

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/ThemeModel.dart';

class LoginController extends BaseController {
  Future<bool> pushNewThemes() async {
    ThemeModel defaultTheme =
        ThemeModel(id: 0, bleedingQuestion: "How are you doing?");
    ThemeModel nextTheme =
        ThemeModel(id: 1, bleedingQuestion: "How aren't you doing?");

    bool success = await storageService.addTheme(defaultTheme);
    success = success | await storageService.addTheme(nextTheme);
    return success;
  }

  Future<bool> resetEntriesThemesAndPreferences() async {
    bool success = await storageService.clearEntries();
    success = success | await storageService.clearPreferences();
    success = success | await storageService.clearThemes();
    return success;
  }
}
