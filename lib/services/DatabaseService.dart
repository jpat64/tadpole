// ignore_for_file: file_names

import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService();

  static DatabaseService instance() => _instance;

  static Future<void> initialize() async {
    await Hive.initFlutter();
  }
}
