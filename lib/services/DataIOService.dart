// ignore_for_file: file_names

import 'dart:io';

import 'package:moonbase/services/DatabaseService.dart';
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
}
