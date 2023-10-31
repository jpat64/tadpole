// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/LoginController.dart';
import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/models/ThemeModel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _key = GlobalKey();

  LoginController controller = LoginController();

  @override
  void initState() {
    super.initState();
  }

  @override
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
              ElevatedButton(
                onPressed: () async {
                  PreferencesModel preferences =
                      await controller.getPreferences();
                  ThemeModel selectedTheme =
                      await controller.getTheme(preferences.themeId);
                  if (preferences.loginType == LoginType.none) {
                    if (!mounted) return;
                    Navigator.pushNamed(context, "/today");
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
