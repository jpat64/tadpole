// ignore_for_file: file_names

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/EntryModel.dart';

class ActivitiesController extends BaseController {
  Future<List<Activity>> getActivities() async {
    return storageService.getActivities();
  }
}
