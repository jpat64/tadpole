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
  List<Activity>? activities;

  String? newActivityText;

  ActivitiesController controller = ActivitiesController();

  TextEditingController entryTextController = TextEditingController();

  @override
  Future<void> loadLocalData() async {
    List<Activity> a = await controller.getActivities();
    setState(() {
      activities = a.where((element) => element.deleted == false).toList();
    });
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activities"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Add a new Activity here...",
                      ),
                      controller: entryTextController,
                      onChanged: (value) {
                        setState(() {
                          newActivityText = value;
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () async {
                        bool success =
                            await controller.addActivity(newActivityText);
                        if (success) {
                          setState(() {
                            newActivityText = "";
                          });
                          entryTextController.text = "";
                        }
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView(
                children: activities != null
                    ? activities!.map<ListTile>((element) {
                        return ListTile(
                            title: Text(element.text),
                            trailing: ElevatedButton(
                              onPressed: () {
                                controller.deleteActivity(element);
                              },
                              child: const Icon(Icons.delete_outline),
                            ));
                      }).toList()
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
