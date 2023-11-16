// ignore_for_file: file_names

import 'dart:convert';

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/services/StorageService.dart';

class ActivitiesController extends BaseController {
  Future<List<Activity>> getActivities() async {
    return storageService.getActivities();
  }

  Future<bool> addActivity(String? newActivityText) async {
    if (newActivityText?.isNotEmpty ?? false) {
      List<Activity> activities = await storageService.getActivities();
      Activity addableActivity =
          Activity(text: newActivityText!, id: activities.length);
      bool exists = false;
      for (Activity a in activities) {
        if (a.text == newActivityText) {
          a.deleted = false;
          exists = true;
        }
      }
      if (!exists) {
        activities.add(addableActivity);
      }
      return await storageService.setTable(
          StorageService.ACTIVITIES,
          activities.map<String>((element) {
            return json.encode(element.toJson());
          }).toList());
    }

    return false;
  }

  Future<bool> deleteActivity(Activity activity) async {
    List<Activity> activities = await storageService.getActivities();
    if (activities.contains(activity)) {
      activities.where((element) => element == activity).first.deleted = true;
    }
    return await storageService.setTable(
        StorageService.ACTIVITIES,
        activities.map<String>((element) {
          return json.encode(element.toJson());
        }).toList());
  }
}
