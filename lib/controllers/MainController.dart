// ignore_for_file: file_names

import 'package:tadpole/services/StorageService.dart';

class MainController {
  final StorageService storageService = StorageService();

  Future<List<String>?> getInputs() async {
    return storageService.getInputs();
  }

  Future<bool> storeInputs(List<String>? inputs) async {
    return storageService.storeInputs(inputs);
  }
}
