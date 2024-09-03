// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:moonbase/routes/router.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:moonbase/utils/MoonbaseTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const Moonbase(),
  );
}

class Moonbase extends StatelessWidget {
  const Moonbase({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Moonbase',
      theme: ThemeData(
        colorScheme: Palette.basic.lightTheme,
        textButtonTheme: MoonbaseTheme.textButtonTheme,
        textTheme: MoonbaseTheme.textTheme,
      ),
      darkTheme: ThemeData(colorScheme: Palette.basic.darkTheme),
      routerConfig: router,
    );
  }
}
