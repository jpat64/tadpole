// ignore_for_file: file_names

import 'dart:convert';

class PreferencesModel {
  LoginType loginType;
  String? password;
  int themeId;

  PreferencesModel({
    required this.loginType,
    this.password,
    required this.themeId,
  });

  static PreferencesModel fromJsonString(String jsonString) {
    Map<String, dynamic> jsonOfString = json.decode(jsonString);
    return PreferencesModel(
      loginType: LoginType.parse(jsonOfString['login_type']),
      password: jsonOfString['password'],
      themeId: jsonOfString['theme_id'] ?? 0,
    );
  }

  String toJsonString() {
    return json.encode(this);
  }
}

enum LoginType {
  none,
  bio,
  password;

  static LoginType parse(String input) {
    switch (input) {
      case "NONE":
        return LoginType.none;
      case "BIO":
        return LoginType.bio;
      case "PASS":
        return LoginType.password;
      default:
        throw Exception("unknown loginType: $input");
    }
  }

  @override
  String toString() {
    switch (this) {
      case LoginType.none:
        return "NONE";
      case LoginType.bio:
        return "BIO";
      case LoginType.password:
        return "PASS";
      default:
        throw Exception("unknown LoginType: $this");
    }
  }
}
