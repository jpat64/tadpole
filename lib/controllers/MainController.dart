// ignore_for_file: file_names

import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/services/StorageService.dart';

class MainController {
  final StorageService storageService = StorageService();

  List<Entry>? entries;
  List<Symptom>? symptoms;
  List<Activity>? activities;
}
