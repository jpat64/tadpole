// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:moonbase/utils/data/Triple.dart';
import 'package:moonbase/utils/data/Tuple.dart';

class MoonbaseDayButton extends StatelessWidget {
  final Color textColor;
  final Tuple<Color, Color> activeColors;
  final Tuple<Color, Color> inactiveColors;
  final Triple<String, DateTime, Triple<bool, bool, bool>?> data;

  const MoonbaseDayButton(
      {super.key,
      required this.textColor,
      required this.activeColors,
      required this.inactiveColors,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            data.third != null ? activeColors.first : inactiveColors.first,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15))),
      ),
      onPressed: () {
        context.pushNamed("/entry", pathParameters: <String, String>{
          "epochDate": "${DateTimeUtils.epochDays(data.second)}"
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: data.third != null
                        ? activeColors.last
                        : inactiveColors.last,
                    width: 2),
              ),
            ),
            child: Text(
              data.first,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          const Spacer(),
          if (data.third != null)
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              if (data.third!.first)
                Badge(
                  smallSize: 8,
                  backgroundColor: Palette.red[500],
                ),
              if (data.third!.second)
                Badge(
                  smallSize: 8,
                  backgroundColor: Palette.pink[500],
                ),
              if (data.third!.third)
                Badge(
                  smallSize: 8,
                  backgroundColor: Palette.purple[500],
                ),
            ]),
        ],
      ),
    );
  }
}
