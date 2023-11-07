// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tadpole/controllers/LoginController.dart';
import 'package:tadpole/models/PreferencesModel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _key = GlobalKey();

  LoginController controller = LoginController();
  LoginType? loginType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login View"),
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
                  PreferencesModel prefs = await controller.getPreferences();
                  loginType = prefs.loginType;
                  bool addedThemes = await controller.pushNewThemes();
                  if (addedThemes) {
                    if (loginType == LoginType.none) {
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(
                        context,
                        '/today',
                      );
                    } else {
                      // TODO: implement password and biometric authentication
                      throw Exception("not implemented: $loginType");
                    }
                  } else {
                    throw Exception('error: initial themes not added');
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: () async {
            await controller.resetEntriesThemesAndPreferences();
          },
          child: const Text("HARD RESET DATA (emergency use only)")),
    );
  }
}
