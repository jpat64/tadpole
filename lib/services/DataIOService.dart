// ignore_for_file: file_names

import 'dart:io';

import 'package:moonbase/models/ExternalDailyEntryData.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:path_provider/path_provider.dart';

class DataIOService {
  static Future<String> exportDataAsString() async {
    DatabaseService instance = DatabaseService.instance();

    List<String> entriesAsCsvs = instance.getLinesForExport();
    return "Date,Medication,Current,Points,Pallor,Notes,Tags\n${entriesAsCsvs.join("\n")}";
  }

  static Future<String> getFilePath(String path) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    return "$appDocumentsPath/$path";
  }

  static Future<bool> saveFile(String path, String content) async {
    File file = File(path);

    file.writeAsString(content);
    return true;
  }

  static Future<String> readFile(String path) async {
    File file = File(path);

    return await file.readAsString();
  }

  static Future<bool> importContent(String content) async {
    // content is a csv file, \n-separated lines
    List<String> csvStrings = content.split("\n");
    List<ExternalDailyEntryData> externalEntryData = csvStrings
        .map<ExternalDailyEntryData>(
            (element) => ExternalDailyEntryData.fromCsv(csvString: element))
        .toList();

    DatabaseService instance = DatabaseService.instance();
    bool success = true;

    for (ExternalDailyEntryData extEntry in externalEntryData) {
      if (instance.existsEntryForDay(extEntry.epochDate)) {
        Logger.warning(
            "data import conflict: deleting on-device entry for epochDate: ${extEntry.epochDate}");
      }

      success = success || await instance.processExternalEntry(extEntry);
    }

    return success;
  }
}
