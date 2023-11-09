// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget loadingScreen() {
  return const Scaffold(
    body: Center(
      widthFactor: 0.5,
      heightFactor: 0.5,
      child: Column(
        children: [
          Text("Loading data..."),
          Divider(height: 10),
          CircularProgressIndicator(),
        ],
      ),
    ),
  );
}
