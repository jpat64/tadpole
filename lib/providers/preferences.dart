import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/models/ThemeModel.dart';
import 'package:tadpole/services/StorageService.dart';

StorageService storage = StorageService();

final preferencesProvider = FutureProvider<PreferencesModel>((ref) async {
  return PreferencesModel.fromJsonString(
      await storage.getStoredString(StorageService.PREFERENCES));
});

final selectedThemeProvider = FutureProvider<ThemeModel>((ref) async {
  Map<int, ThemeModel> themes = await storage.getThemes();
  return themes[ref.watch(preferencesProvider).value?.themeId] ??
      ThemeModel.base();
});
