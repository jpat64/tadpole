// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/components/MoonbaseDateTimeSelector.dart';
import 'package:moonbase/services/DataIOService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();

  static const String name = "/settings";
  static const int navIndex = 2;
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DateTime relevantDateTime;
  TextEditingController emailTextController = TextEditingController();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  TextEditingController importTextController = TextEditingController();
  final GlobalKey<FormState> _importFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    relevantDateTime =
        DateTime.now(); // used for starting values for date time picker
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Settings", style: TextStyle(fontFamily: "Freeman")),
              ],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Go to Month:"),
              ),
              MoonbaseDateTimeSelector(
                year: relevantDateTime.year,
                month: relevantDateTime.month,
              ),
              Divider(color: Palette.tan[500]!),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Go to Date:"),
              ),
              MoonbaseDateTimeSelector(
                year: relevantDateTime.year,
                month: relevantDateTime.month,
                day: relevantDateTime.day,
              ),
              Divider(color: Palette.tan[500]!),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Export Data:"),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Form(
                      key: _emailFormKey,
                      child: AlertDialog(
                        content: ListTile(
                          leading: const Icon(Icons.mail),
                          title:
                              const Text("Send Data to which email address?"),
                          subtitle: TextFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Please enter a valid email address.";
                              }

                              RegExp emailRegex = RegExp(r'.*(@).*(\.).*');
                              if (false == emailRegex.hasMatch(value)) {
                                return "Please enter a valid email adddress (something@somewhere.xyz)";
                              }

                              return null;
                            },
                            controller: emailTextController,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_emailFormKey.currentState?.validate() ??
                                  false) {
                                String content =
                                    await DataIOService.exportDataAsString();
                                String path = await DataIOService.getFilePath(
                                    "data-${DateTimeUtils.epochDays(DateTime.now())}-${Random().nextInt(100)}.csv");
                                DataIOService.saveFile(path, content);

                                Email email = Email(
                                    body:
                                        "Moonbase Data Export on ${DateTimeUtils.stringFromEpochDays(DateTimeUtils.epochDays(DateTime.now()))}",
                                    recipients: [emailTextController.text],
                                    subject: "Moonbase Data Export",
                                    attachmentPaths: [path]);

                                FlutterEmailSender.send(email);
                              }
                            },
                            child: const Text("Send"),
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Export Data",
                  style: TextStyle(color: Palette.white),
                ),
              ),
              Divider(color: Palette.tan[500]!),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Import Data:"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => Form(
                        key: _importFormKey,
                        child: AlertDialog(
                          content: ListTile(
                            leading: const Icon(Icons.mail),
                            title: const Text(
                                "Which File? Make sure it's saved to your device."),
                            subtitle: TextFormField(
                              validator: (value) {
                                if (value == null) {
                                  return "Please enter a valid file path.";
                                }

                                RegExp emailRegex =
                                    RegExp(r'(data-).*(-).*(\.csv)');
                                if (false == emailRegex.hasMatch(value)) {
                                  return "Please enter a valid file path (data-12345-67.csv)";
                                }

                                return null;
                              },
                              controller: importTextController,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (_emailFormKey.currentState?.validate() ??
                                    false) {
                                  String path = await DataIOService.getFilePath(
                                      emailTextController.text);
                                  String content =
                                      await DataIOService.readFile(path);
                                  Logger.info("content: $content");

                                  bool success =
                                      await DataIOService.importContent(
                                          content);
                                  if (success && context.mounted) {
                                    context.pop();
                                  } else {
                                    Logger.warning(
                                        "import data not successful");
                                  }
                                }
                              },
                              child: const Text("Import"),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text("Import Data")),
            ],
          ),
        ),
        bottomNavigationBar:
            const MoonbaseBottomBar(selectedIndex: SettingsScreen.navIndex),
      ),
    );
  }
}
