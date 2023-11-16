import 'package:flutter/material.dart';
import 'package:tadpole/views/ActivitiesView.dart';
import 'package:tadpole/views/ForecastView.dart';
import 'package:tadpole/views/HistoryView.dart';
import 'package:tadpole/views/LoginView.dart';
import 'package:tadpole/views/SettingsView.dart';
import 'package:tadpole/views/StatisticsView.dart';
import 'package:tadpole/views/SymptomsView.dart';
import 'package:tadpole/views/TodayView.dart';

Map<String, Widget Function(BuildContext context)> routes() {
  return {
    '/history': (context) => const HistoryView(),
    '/forecast': (context) => const ForecastView(),
    '/settings': (context) => const SettingsView(),
    '/statistics': (context) => const StatisticsView(),
    '/today': (context) => const TodayView(),
    '/login': (context) => const LoginView(),
    '/activities': (context) => const ActivitiesView(),
    '/symptoms': (context) => const SymptomsView(),
  };
}
