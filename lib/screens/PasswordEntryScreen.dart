// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/services/Logger.dart';
import 'package:moonbase/services/PasswordCheckerService.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moonbase/utils/StringUtils.dart';

class PasswordEntryScreen extends StatefulWidget {
  final String unlock;

  const PasswordEntryScreen({super.key, required this.unlock});

  @override
  State<PasswordEntryScreen> createState() => _PasswordEntryScreenState();

  static const String name = "/password";
}

class _PasswordEntryScreenState extends State<PasswordEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Palette.basic.background,
        appBar: AppBar(
          title: Text("Unlock ${widget.unlock} Mode"),
        ),
        body: LayoutBuilder(
            builder: (context, constraints) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: constraints.biggest.height * 0.05),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Palette.basic.off,
                          ),
                          child: Image.asset(
                            "assets/images/ui display/lock.png",
                            width: constraints.biggest.width * 0.7,
                            height: constraints.biggest.width * 0.7,
                          ),
                        ),
                        SizedBox(height: constraints.biggest.height * 0.05),
                        Text(
                          "Trying to unlock ${widget.unlock} mode?",
                          style: TextStyle(
                              fontSize: 26, color: Palette.basic.text),
                        ),
                        SizedBox(height: constraints.biggest.height * 0.05),
                        Text(
                          "Please enter an acceptable password related to the topic. If it fits, you've unlocked ${widget.unlock} mode!",
                          style: TextStyle(
                              fontSize: 14, color: Palette.basic.text),
                        ),
                        SizedBox(height: constraints.biggest.height * 0.05),
                        TextFormField(
                          controller: textController,
                          decoration: InputDecoration(
                            fillColor: Palette.basic.secondary,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Palette.basic.primary, width: 2)),
                          ),
                        ),
                        SizedBox(height: constraints.biggest.height * 0.05),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Palette.basic.primary,
                              foregroundColor: Palette.basic.background),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              Logger.info(
                                  "password entered: [${textController.text}] for [${widget.unlock}]");
                              PasswordCheckerService pwCheck =
                                  PasswordCheckerService();
                              var success = await pwCheck.unlockStyleTheme(
                                  'secret', textController.text.trim());
                              if (success && context.mounted) {
                                Logger.info(
                                    "PasswordEntryScreen .. unlock() success!");
                                Fluttertoast.showToast(
                                    msg:
                                        "${widget.unlock.capitalize()} Mode unlocked!",
                                    backgroundColor: Palette.basic.accent,
                                    textColor: Palette.basic.text);
                                DatabaseService instance =
                                    DatabaseService.instance;
                                bool success =
                                    await instance.unlockTheme(widget.unlock);
                                if (success) {
                                  if (widget.unlock == "secret") {
                                    SharedPreferencesService.setSecretModeFlag(
                                        true);
                                  }
                                  if (context.mounted) {
                                    context.goNamed(CalendarScreen.name,
                                        pathParameters: {
                                          "epochDate":
                                              "${DateTimeUtils.epochDays(DateUtils.addDaysToDate(DateTime.now(), 0))}"
                                        });
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Something went wrong unlocking ${widget.unlock} mode, but the password was correct!",
                                    backgroundColor: Palette.basic.error,
                                    textColor: Palette.basic.text,
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "That didn't work. Try again.",
                                    backgroundColor: Palette.basic.error,
                                    textColor: Palette.basic.text);
                                Logger.info(
                                    "PasswordEntryScreen .. unlock() failure!");
                              }
                            }
                          },
                          child: const Text("Unlock"),
                        ),
                        SizedBox(height: constraints.biggest.height * 0.05),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Palette.basic.primary,
                              foregroundColor: Palette.basic.background),
                          onPressed: () {
                            context
                                .goNamed(CalendarScreen.name, pathParameters: {
                              "epochDate":
                                  "${DateTimeUtils.epochDays(DateUtils.addDaysToDate(DateTime.now(), 0))}"
                            });
                          },
                          child: const Text("Cancel"),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
