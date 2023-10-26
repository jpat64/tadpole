// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class MainController {
  Future<List<String>?> getInputs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("tadpole_items");
  }

  Future<bool> storeInputs(List<String>? inputs) async {
    if (inputs == null) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setStringList("tadpole_items", inputs);
      return true;
    } catch (e) {
      throw Exception("ERROR: unable to save inputs $e");
    }
  }
}
