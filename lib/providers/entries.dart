import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/services/StorageService.dart';

StorageService storage = StorageService();

final allEntriesProvider = FutureProvider<Map<int, Entry>>((ref) async {
  List<Entry> rawEntries = await storage.getEntries();
  return Map<int, Entry>.fromEntries(
      rawEntries.map<MapEntry<int, Entry>>((element) {
    return MapEntry<int, Entry>(element.id, element);
  }));
});
