// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.red[200]!, width: 3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text("Page information is still loading..."),
                      const SizedBox(height: 10),
                      CircularProgressIndicator(
                        color: Colors.red[400],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
