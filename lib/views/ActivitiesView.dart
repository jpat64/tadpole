// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/ActivitiesController.dart';
import 'package:tadpole/helpers/LocalStorageState.dart';
import 'package:tadpole/models/EntryModel.dart';

class ActivitiesView extends StatefulWidget {
  const ActivitiesView({super.key});

  @override
  State createState() => _ActivitiesViewState();
}

class _ActivitiesViewState extends LocalStorageState<ActivitiesView> {
  final GlobalKey<FormState> _key = GlobalKey();
  List<Activity>? activities;

  ActivitiesController controller = ActivitiesController();

  @override
  Future<void> loadLocalData() async {
    List<Activity> a = await controller.getActivities();
    setState(() {
      activities = a;
    });
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activities View"),
      ),
      body: Container(),
    );
  }
}
