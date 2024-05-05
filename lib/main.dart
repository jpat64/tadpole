import 'package:flutter/material.dart';
import 'package:moonbase/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Moonbase());
}

class Moonbase extends StatelessWidget {
  const Moonbase({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
