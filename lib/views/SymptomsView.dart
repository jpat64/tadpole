// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/SymptomsController.dart';
import 'package:tadpole/helpers/LocalStorageState.dart';
import 'package:tadpole/models/EntryModel.dart';

class SymptomsView extends StatefulWidget {
  const SymptomsView({super.key});

  @override
  State createState() => _SymptomsViewState();
}

class _SymptomsViewState extends LocalStorageState<SymptomsView> {
  List<Symptom>? symptoms;

  String? newSymptomText;

  SymptomsController controller = SymptomsController();

  TextEditingController entryTextController = TextEditingController();

  @override
  Future<void> loadLocalData() async {
    List<Symptom> s = await controller.getSymptoms();
    setState(() {
      symptoms = s.where((element) => element.deleted == false).toList();
    });
  }

  @override
  Widget buildAfterLoad(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptoms"),
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
                        hintText: "Add a new Symptom here...",
                      ),
                      onChanged: (value) {
                        setState(() {
                          newSymptomText = value;
                        });
                      },
                      controller: entryTextController,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () async {
                        bool success =
                            await controller.addSymptom(newSymptomText);
                        if (success) {
                          setState(() {
                            newSymptomText = null;
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
                children: symptoms != null
                    ? symptoms!.map<ListTile>((element) {
                        return ListTile(
                            title: Text(element.text),
                            trailing: ElevatedButton(
                              onPressed: () {
                                controller.deleteSymptom(element);
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
