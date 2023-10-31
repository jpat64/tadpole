// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/TodayController.dart';
import 'package:tadpole/models/EntryModel.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  final GlobalKey<FormState> _key = GlobalKey();

  TodayController controller = TodayController();

  // bleeding is in the form
  bool bleeding = false;

  List<Entry>? entries;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today View"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: Column(
            children: [
              const Text("Welcome to Tadpole!"),
              Row(
                children: [
                  const Text("Are you bleeding?"),
                  const Spacer(),
                  Checkbox(
                      value: bleeding,
                      onChanged: (value) {
                        setState(() {
                          bleeding = value ?? bleeding;
                        });
                      })
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  controller.addEntry(bleeding);
                },
                child: const Text("Submit"),
              ),
              const Divider(height: 10),
              ElevatedButton(
                onPressed: () async {
                  List<Entry> foundEntries = await controller.getEntries();
                  setState(() {
                    entries = foundEntries;
                  });
                },
                child: const Text("Refresh Entries"),
              ),
              if (entries != null)
                Column(
                  children: entries!.map<Text>((element) {
                    return Text(
                        "${element.id} | ${element.date} | ${element.bleeding}");
                  }).toList(),
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
            child: const Text("Settings"),
          )
        ],
      ),
    );
  }
}
