// ignore_for_file: file_names

import 'package:moonbase/services/DatabaseService.dart';

class PasswordCheckerService {
  DatabaseService instance = DatabaseService.instance();

  Future<bool> unlockStyleTheme(String themeName, String givenPassword) async {
    if (themeName == 'secret') {
      return _unlockSecretMode(givenPassword);
    } else {
      return _unlockStyleThemeWithPassword(themeName, givenPassword);
    }
  }

  Future<bool> _unlockStyleThemeWithPassword(
      String themeName, String givenPassword) async {
    return await Future<bool>.delayed(const Duration(seconds: 5), () => false);
  }

  Future<bool> _unlockSecretMode(String givenPassword) async {
    // the password for Secret Mode is not really secret, just as an example
    if (['period', 'menstruation'].contains(givenPassword.toLowerCase())) {
      instance.unlockTheme('secret');
      return true;
    }
    return false;
  }
}
