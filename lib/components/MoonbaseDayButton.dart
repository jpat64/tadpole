// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:moonbase/utils/data/Triple.dart';

class MoonbaseDayButton extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color hoverColor;
  final Triple<String, DateTime, bool?> data;

  const MoonbaseDayButton(
      {super.key,
      required this.textColor,
      required this.hoverColor,
      required this.backgroundColor,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: () {
        context.goNamed("/entry", pathParameters: <String, String>{
          "epochDate": "${DateTimeUtils.epochDays(data.second)}"
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            data.first,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
          const Spacer(),
          if (data.third != null)
            Badge(
              smallSize: 12,
              backgroundColor:
                  data.third! ? Palette.red[500] : Palette.blue[500],
            ),
        ],
      ),
    );
  }
}
