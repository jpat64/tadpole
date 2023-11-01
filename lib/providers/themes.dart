import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tadpole/models/ThemeModel.dart';
import 'package:tadpole/services/StorageService.dart';

StorageService storage = StorageService();

final allThemesProvider = FutureProvider<Map<int, ThemeModel>>((ref) async {
  return await storage.getThemes();
});
