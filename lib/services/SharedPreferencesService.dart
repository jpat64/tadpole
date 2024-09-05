// ignore_for_file: file_names, constant_identifier_names
import 'package:moonbase/services/Logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String SELECTED_THEME_NAME = "moonbaseprefs-selected-theme-name";
  static const String FIRST_TIME_FLAG = "moonbaseprefs-first-time-flag";
  static const String SECRET_MODE_FLAG = "moonbaseprefs-secret-mode-flag";

  static final Map<String, SharedPreferencesDataType> _nameToTypeMap = {
    SharedPreferencesService.SELECTED_THEME_NAME:
        SharedPreferencesDataType.string,
    SharedPreferencesService.SECRET_MODE_FLAG: SharedPreferencesDataType.bool,
    SharedPreferencesService.FIRST_TIME_FLAG: SharedPreferencesDataType.bool,
  };

  static Future<dynamic> _getValue(String valueName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    SharedPreferencesDataType? whichDataType = _nameToTypeMap[valueName];
    switch (whichDataType) {
      case SharedPreferencesDataType.string:
        return prefs.getString(valueName);
      case SharedPreferencesDataType.bool:
        return prefs.getBool(valueName);
      case SharedPreferencesDataType.int:
        return prefs.getInt(valueName);
      case null:
        Logger.warning("$valueName did not map to a valid data type");
        return;
    }
  }

  static Future<void> _setValue(String valueName, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    SharedPreferencesDataType? whichDataType = _nameToTypeMap[valueName];
    switch (whichDataType) {
      case SharedPreferencesDataType.string:
        assert(
            value is String,
            Logger.warning(
                "$valueName can only be set to a String, not whatever [$value]'s type is."));
        prefs.setString(valueName, value as String);
      case SharedPreferencesDataType.bool:
        assert(
            value is bool,
            Logger.warning(
                "$valueName can only be set to a bool, not whatever [$value]'s type is."));
        prefs.setBool(valueName, value as bool);
      case SharedPreferencesDataType.int:
        assert(
            value is int,
            Logger.warning(
                "$valueName can only be set to an int, not whatever [$value]'s type is."));
        prefs.setInt(valueName, value as int);
      case null:
        Logger.warning("$valueName did not map to a valid data type");
    }
  }

  static Future<void> setSelectedThemeName(String selectedThemeName) async {
    await _setValue(SELECTED_THEME_NAME, selectedThemeName);
  }

  static Future<String> get selectedThemeName async {
    return await _getValue(SharedPreferencesService.SELECTED_THEME_NAME);
  }

  static Future<void> setSecretModeFlag(bool selectedThemeName) async {
    await _setValue(SECRET_MODE_FLAG, selectedThemeName);
  }

  static Future<bool?> get secretModeFlag async {
    return await _getValue(SharedPreferencesService.SECRET_MODE_FLAG);
  }

  static Future<void> setFirstTimeFlag(bool firstTimeFlag) async {
    await _setValue(FIRST_TIME_FLAG, firstTimeFlag);
  }

  static Future<bool> get firstTimeFlag async {
    return await _getValue(SharedPreferencesService.FIRST_TIME_FLAG);
  }
}

enum SharedPreferencesDataType {
  bool,
  string,
  int;
}
