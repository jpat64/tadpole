// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tadpole/controllers/LoginController.dart';
import 'package:tadpole/models/PreferencesModel.dart';
import 'package:tadpole/providers/preferences.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final GlobalKey<FormState> _key = GlobalKey();

  LoginController controller = LoginController();
  late LoginType loginType;

  @override
  void initState() {
    super.initState();

    //loginType =
    //  ref.watch(preferencesProvider).value?.loginType ?? LoginType.none;
  }

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
                  loginType = ref.watch(preferencesProvider).value?.loginType ??
                      LoginType.none;
                  if (loginType == LoginType.none) {
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(
                      context,
                      '/today',
                    );
                  } else {
                    print("not implemented: $loginType");
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
