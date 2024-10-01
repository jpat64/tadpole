// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/components/MoonbaseBottomBar.dart';
import 'package:moonbase/components/MoonbaseDateTimeSelector.dart';
import 'package:moonbase/models/StyleTheme.dart';
import 'package:moonbase/screens/PasswordEntryScreen.dart';
import 'package:moonbase/screens/WelcomeSequenceScreen.dart';
import 'package:moonbase/services/DataIOService.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();

  static const String name = "/settings";
  static const int navIndex = 3;
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DateTime relevantDateTime;
  TextEditingController emailTextController = TextEditingController();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  TextEditingController importTextController = TextEditingController();
  final GlobalKey<FormState> _importFormKey = GlobalKey<FormState>();

  Palette? palette;
  bool? secretMode;
  StyleTheme? selectedTheme;
  late bool secretModeUnlocked;
  late bool froggyModeUnlocked;

  bool loaded = false;

  @override
  void initState() {
    super.initState();
    secretModeUnlocked = false;
    froggyModeUnlocked = false;
    relevantDateTime =
        DateTime.now(); // used for starting values for date time picker
  }

  Future<void> wasSecretModeUnlocked() async {
    DatabaseService instance = DatabaseService.instance;
    StyleTheme? secretTheme = instance.getTheme('secret');
    setState(() {
      if (secretTheme != null) {
        secretModeUnlocked = secretTheme.unlocked;
      } else {
        secretModeUnlocked = false;
      }
    });
  }

  Future<void> wasFroggyModeUnlocked() async {
    DatabaseService instance = DatabaseService.instance;
    StyleTheme? froggyTheme = instance.getTheme('froggy');
    setState(() {
      if (froggyTheme != null) {
        froggyModeUnlocked = froggyTheme.unlocked;
      } else {
        froggyModeUnlocked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timestamp) async {
      if (!loaded) {
        if (palette == null) {
          Palette foundPalette = await Palette.currentPalette;
          setState(() {
            palette = foundPalette;
          });
        }
        if (selectedTheme == null) {
          StyleTheme foundSelectedTheme = DatabaseService.instance
                  .getTheme(await SharedPreferencesService.selectedThemeName) ??
              StyleTheme(paletteName: 'basic', unlocked: true);
          setState(() {
            selectedTheme = foundSelectedTheme;
          });
        }
        if (secretMode == null) {
          bool? foundSecretMode = await SharedPreferencesService.secretModeFlag;
          setState(() {
            secretMode = foundSecretMode;
          });
        }
        await wasSecretModeUnlocked();
        await wasFroggyModeUnlocked();
        setState(() {
          loaded = true;
        });
      }
    });
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: palette?.iconTheme,
          backgroundColor: palette?.background,
          titleTextStyle: palette?.titleTextTheme,
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
        backgroundColor: palette?.background ?? Palette.basic.background,
        body: LayoutBuilder(
          builder: (context, constraints) => Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Navigation", style: TextStyle(fontSize: 22))),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Go to Month:"),
                ),
                MoonbaseDateTimeSelector(
                  year: relevantDateTime.year,
                  month: relevantDateTime.month,
                  constraints: constraints,
                ),
                Divider(color: palette?.primary),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Go to Date:"),
                ),
                MoonbaseDateTimeSelector(
                  year: relevantDateTime.year,
                  month: relevantDateTime.month,
                  day: relevantDateTime.day,
                  constraints: constraints,
                ),
                Divider(color: palette?.primary),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Import and Export Data",
                        style: TextStyle(fontSize: 22))),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: palette?.primary,
                          foregroundColor: palette?.background),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Form(
                            key: _emailFormKey,
                            child: AlertDialog(
                              content: ListTile(
                                leading: const Icon(Icons.mail),
                                title: const Text(
                                    "Send Data to which email address?"),
                                subtitle: TextFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please enter a valid email address.";
                                    }

                                    RegExp emailRegex =
                                        RegExp(r'.*(@).*(\.).*');
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
                                  style: TextButton.styleFrom(
                                      backgroundColor: palette?.background,
                                      foregroundColor: palette?.text),
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: palette?.primary,
                                      foregroundColor: palette?.background),
                                  onPressed: () async {
                                    if (_emailFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      String content = await DataIOService
                                          .exportDataAsString();
                                      String path = await DataIOService.getFilePath(
                                          "data-${DateTimeUtils.epochDays(DateTime.now())}-${Random().nextInt(100)}.csv");
                                      DataIOService.saveFile(path, content);

                                      Email email = Email(
                                          body:
                                              "Moonbase Data Export on ${DateTimeUtils.stringFromEpochDays(DateTimeUtils.epochDays(DateTime.now()))}",
                                          recipients: [
                                            emailTextController.text
                                          ],
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
                        "Export",
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: palette?.accent,
                          foregroundColor: palette?.text),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => Form(
                            key: _importFormKey,
                            child: AlertDialog(
                              content: ListTile(
                                leading: const Icon(Icons.import_export),
                                title: const Text(
                                    "Which File? Make sure it's saved to your device."),
                                subtitle: TextFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please enter a valid file path.";
                                    }

                                    RegExp importRegex =
                                        RegExp(r'(data-).*(-).*(\.csv)');
                                    if (false == importRegex.hasMatch(value)) {
                                      return "Please enter a valid file path (data-12345-67.csv)";
                                    }

                                    return null;
                                  },
                                  controller: importTextController,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: palette?.background,
                                      foregroundColor: palette?.text),
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: palette?.accent,
                                      foregroundColor: palette?.background),
                                  onPressed: () async {
                                    if (_importFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      String path =
                                          await DataIOService.getFilePath(
                                              importTextController.text);
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
                      child: const Text("Import"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette?.error,
                        foregroundColor: palette?.text,
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const ListTile(
                              leading: Icon(Icons.warning),
                              title: Text(
                                  "Are you sure you want to delete your local data?"),
                              subtitle: Text(
                                  "We DON'T store your data anywhere else, so if it's lost, then it's gone forever.\n"
                                  "We recommend you use the Export Data feature to save the data somewhere before deleting it."),
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: palette?.background,
                                    foregroundColor: palette?.text),
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: palette?.error,
                                    foregroundColor: palette?.text),
                                onPressed: () async {
                                  DatabaseService instance =
                                      DatabaseService.instance;
                                  bool success =
                                      await instance.deleteDataFromBoxes();
                                  if (false == success) {
                                    Logger.info("Deleted data from Boxes");
                                  }
                                },
                                child: const Text("Delete"),
                              )
                            ],
                          ),
                        );
                      },
                      child: const Text("Delete Data"),
                    ),
                  ],
                ),
                Divider(color: palette?.primary),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Themes", style: TextStyle(fontSize: 22))),
                if (secretModeUnlocked)
                  ListTile(
                    title: const Text(
                      "Secret Mode",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Switch(
                      inactiveThumbColor:
                          palette?.disabled ?? Palette.basic.disabled,
                      inactiveTrackColor: palette?.off ?? Palette.basic.off,
                      value: secretMode ?? false,
                      onChanged: (value) {
                        setState(() {
                          secretMode = value;
                        });
                        SharedPreferencesService.setSecretModeFlag(value);
                      },
                    ),
                  ),
                if (!secretModeUnlocked)
                  SizedBox(
                    width: constraints.biggest.width * 0.9,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: palette?.primary,
                          foregroundColor: palette?.background),
                      onPressed: () => context.goNamed(PasswordEntryScreen.name,
                          pathParameters: {"unlock": "secret"}),
                      child: const Text("Unlock Secret Mode"),
                    ),
                  ),
                ExpansionTile(
                    title: const Text("Choose Theme"),
                    initiallyExpanded: true,
                    children: DatabaseService.instance.themes
                        .where((element) => element.paletteName != 'secret')
                        .map<Widget>((element) {
                      Palette themePalette =
                          Palette.palettesByName[element.paletteName] ??
                              Palette.basic;
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: themePalette.primary, width: 3)),
                        child: ListTile(
                          textColor: element.unlocked
                              ? themePalette.text
                              : themePalette.disabled,
                          tileColor: themePalette.background,
                          onTap: () async {
                            if (element.unlocked) {
                              await SharedPreferencesService
                                  .setSelectedThemeName(element.paletteName);
                              setState(() {
                                selectedTheme = element;
                              });
                              Fluttertoast.showToast(
                                  msg: "Theme will change next screen!");
                            } else {
                              context.pushNamed(PasswordEntryScreen.name,
                                  pathParameters: {
                                    "unlock": element.paletteName
                                  });
                            }
                          },
                          title: Text(element.paletteName),
                          trailing: SizedBox(
                              width: constraints.biggest.width * 0.5,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: themePalette.swatches
                                      .map<Badge>((element) => Badge(
                                            backgroundColor: element,
                                            smallSize: 24,
                                          ))
                                      .toList())),
                        ),
                      );
                    }).toList()),
                SizedBox(
                  width: constraints.biggest.width * 0.9,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: palette?.primary,
                        foregroundColor: palette?.background),
                    onPressed: () =>
                        context.goNamed(WelcomeSequenceScreen.name),
                    child: const Text("See Intro Again"),
                  ),
                ),
                Divider(color: palette?.primary),
                SizedBox(
                  width: constraints.biggest.width * 0.9,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: palette?.primary,
                        foregroundColor: palette?.background),
                    onPressed: () async {
                      await SharedPreferencesService.setSelectedThemeName(
                          "basic");
                      for (StyleTheme theme
                          in DatabaseService.instance.themes) {
                        if (theme.paletteName != "basic") {
                          await DatabaseService.instance
                              .lockTheme(theme.paletteName);
                        }
                      }
                    },
                    child:
                        const Text("Reset Unlocked Themes (and Secret Mode)"),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: MoonbaseBottomBar(
            palette: palette ?? Palette.basic,
            selectedIndex: SettingsScreen.navIndex),
      ),
    );
  }
}
