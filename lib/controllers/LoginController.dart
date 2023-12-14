// ignore_for_file: file_names

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/ThemeModel.dart';

class LoginController extends BaseController {
  /// since the dropdownmenu requires there to be at least one theme, this method exists.
  /// should be melded into whatever method we write here for first-time initialization.
  Future<bool> pushNewThemes() async {
    ThemeModel defaultTheme = ThemeModel(
      id: 0,
      bleedingQuestion: "How are you doing?",
      newCycleQuestion: "Is Today the first day of a new cycle?",
      painQuestion: "1-5: pain level?",
      flowQuestion: "1-5: flow heaviness?",
      temperatureQuestion: "What's your temperature?",
      symptomQuestion: "What are your symptoms?",
      activityQuestion: "Which activities have you done?",
    );
    ThemeModel nextTheme = ThemeModel(
      id: 1,
      bleedingQuestion: "How aren't you doing?",
      newCycleQuestion: "Isn't Today the first day of a new cycle?",
      painQuestion: "1-5: pain leveln't?",
      flowQuestion: "1-5: flow heavinessn't?",
      temperatureQuestion: "What's not your temperature?",
      symptomQuestion: "What aren't your symptoms?",
      activityQuestion: "Which activities haven't you done?",
    );

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
