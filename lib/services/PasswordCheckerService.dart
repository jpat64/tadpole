// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/KeyGeneratorService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';

class PasswordCheckerService {
  DatabaseService instance = DatabaseService.instance;

  Future<bool> unlockStyleTheme(String themeName, String givenPassword) async {
    if (themeName == 'secret') {
      return _unlockSecretMode(givenPassword);
    } else {
      return _unlockStyleThemeWithPassword(themeName, givenPassword);
    }
  }

  Future<bool> _unlockStyleThemeWithPassword(
      String themeName, String givenPassword) async {
    Logger.info(
        "_unlockStyleThemeWithPassword() current directory: ${Directory.current}");
    switch (themeName) {
      case 'froggy':
        return _unlockStyleThemeFromFile("frogandtoad", givenPassword);
      case 'princess':
        return _unlockStyleThemeFromFile("cinderella", givenPassword);
      default:
        throw UnimplementedError("Mode $themeName not supported yet.");
    }
  }

  Future<bool> _unlockStyleThemeFromFile(
      String fileName, String givenPassword) async {
    RegExp justLetters = RegExp('[a-z]+');
    // get the unlockKey
    String unlockKey = await SharedPreferencesService.unlockKey;
    int unlockKeyInt = KeyGeneratorService.decipherKey(unlockKey);
    // get the list of words
    List<String> words = (await rootBundle
            .loadString("assets/passwords/filtered/filtered-cinderella.txt"))
        .trim()
        .split("\n")
        .map<String>(
            (element) => justLetters.firstMatch(element)?.group(0) ?? "")
        .toList();
    // verify that the number associated with unlockKey maps to a word
    assert(unlockKeyInt < words.length,
        "unlockKey should not be larger than words.length (key: $unlockKey, length: ${words.length})");
    // compare the associated word with givenPassword, and return whether or not they are equal
    Logger.info(
        "PasswordCheckerService _unlockStyleThemeFromFile() looking for [${words[unlockKeyInt]}] and got [$givenPassword]");
    return words[unlockKeyInt] == givenPassword;
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
