// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/screens/PasswordEntryScreen.dart';
import 'package:moonbase/services/SharedPreferencesService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';

class WelcomeSequenceScreen extends StatefulWidget {
  const WelcomeSequenceScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeSequenceScreenState();

  static const String name = '/welcome';
}

class _WelcomeSequenceScreenState extends State<WelcomeSequenceScreen> {
  int step = 0;

  @override
  void initState() {
    super.initState();
    step = 0;
  }

  List<Widget> getColumn(int step, BoxConstraints constraints) {
    assert(step < 3);
    assert(step >= 0);
    List<Widget> contents = <Widget>[];
    switch (step) {
      case 0:
        contents.add(
          Image.asset(
            "assets/images/ui display/moon.png",
            height: constraints.biggest.height * 0.6,
            width: constraints.biggest.width * 0.6,
          ),
        );
        contents.add(
          SizedBox(height: constraints.biggest.height * 0.05),
        );
        contents.add(
          TextButton(
            onPressed: () {
              setState(() {
                step = 1;
              });
            },
            child: const Text("Next"),
          ),
        );
        return contents;
      case 1:
        contents.add(
          Image.asset(
            "assets/images/ui display/notes.png",
            height: constraints.biggest.height * 0.6,
            width: constraints.biggest.width * 0.6,
          ),
        );
        contents.add(
          SizedBox(height: constraints.biggest.height * 0.05),
        );
        contents.add(
          TextButton(
            onPressed: () {
              setState(() {
                step = 2;
              });
            },
            child: const Text("Next"),
          ),
        );
        return contents;
      case 2:
        contents.add(
          Image.asset(
            "assets/images/ui display/inspect.png",
            height: constraints.biggest.height * 0.6,
            width: constraints.biggest.width * 0.6,
          ),
        );
        contents.add(
          SizedBox(height: constraints.biggest.height * 0.05),
        );
        contents.add(
          TextButton(
            onPressed: () => context.goNamed(CalendarScreen.name),
            child: const Text("Next"),
          ),
        );
        return contents;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.basic.background,
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (step == 0)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Palette.basic.primary,
                        border: Border.all(color: Palette.basic.primary)),
                    child: Image.asset(
                      "assets/images/ui display/moon.png",
                      height: constraints.biggest.width * 0.7,
                      width: constraints.biggest.width * 0.7,
                    ),
                  ),
                if (step == 1)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Palette.basic.secondary,
                        border: Border.all(color: Palette.basic.primary)),
                    child: Image.asset(
                      "assets/images/ui display/notes.png",
                      height: constraints.biggest.height * 0.55,
                      width: constraints.biggest.width * 0.7,
                    ),
                  ),
                if (step == 2)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Palette.basic.off,
                        border: Border.all(color: Palette.basic.primary)),
                    child: Image.asset(
                      "assets/images/ui display/inspect.png",
                      height: constraints.biggest.width * 0.7,
                      width: constraints.biggest.width * 0.7,
                    ),
                  ),
                SizedBox(height: constraints.biggest.height * 0.05),
                if (step == 0)
                  const Text("Welcome to Moonbase!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (step == 1)
                  const Text("Here's what you can track.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (step == 2)
                  const Text("Think you know us?",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: constraints.biggest.height * 0.05),
                if (step == 0)
                  const Text(
                      "Use this app to help track statistics and gain analytics, with complete control of your information.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)),
                if (step == 1)
                  const Text(
                      "This app lets you track your information as granually as you'd like, from checkboxes to scales, tags, and notes.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)),
                if (step == 2)
                  const Text(
                      "If you think you know what this app is for, you can try to unlock Secret Mode here. Otherwise, you can continue in Normal Mode.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)),
                SizedBox(height: constraints.biggest.height * 0.05),
                const Spacer(),
                if (step <= 1)
                  SizedBox(
                    width: constraints.biggest.width * 0.9,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Palette.basic.primary,
                        foregroundColor: Palette.basic.background,
                      ),
                      onPressed: () {
                        setState(() {
                          step += 1;
                        });
                      },
                      child: const Text("Next"),
                    ),
                  ),
                if (step == 2)
                  SizedBox(
                    width: constraints.biggest.width * 0.9,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Palette.basic.accent,
                        foregroundColor: Palette.basic.background,
                      ),
                      onPressed: () async {
                        await SharedPreferencesService.setFirstTimeFlag(false);
                        if (context.mounted) {
                          context.goNamed(PasswordEntryScreen.name,
                              pathParameters: {"unlock": "secret"});
                        }
                      },
                      child: const Text("Unlock Secret Mode"),
                    ),
                  ),
                if (step == 2)
                  SizedBox(
                    width: constraints.biggest.width * 0.9,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Palette.basic.primary,
                        foregroundColor: Palette.basic.background,
                      ),
                      onPressed: () async {
                        await SharedPreferencesService.setFirstTimeFlag(false);
                        if (context.mounted) {
                          context.goNamed(CalendarScreen.name, pathParameters: {
                            "epochDate":
                                "${DateTimeUtils.epochDays(DateUtils.addDaysToDate(DateTime.now(), 0))}"
                          });
                        }
                      },
                      child: const Text("Normal Mode"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
