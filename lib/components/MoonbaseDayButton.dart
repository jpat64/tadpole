// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonbase/components/MoonbaseBadgeSection.dart';
import 'package:moonbase/models/DailyEntry.dart';
import 'package:moonbase/services/DatabaseService.dart';
import 'package:moonbase/utils/DateTimeUtils.dart';
import 'package:moonbase/utils/Palette.dart';
import 'package:moonbase/utils/data/Pair.dart';

class MoonbaseDayButton extends StatelessWidget {
  final Color textColor;
  final Pair<Color, Color> activeColors;
  final Pair<Color, Color> inactiveColors;
  final Pair<String, DateTime?>? data;

  const MoonbaseDayButton(
      {super.key,
      required this.textColor,
      required this.activeColors,
      required this.inactiveColors,
      required this.data});

  @override
  Widget build(BuildContext context) {
    DatabaseService instance = DatabaseService.instance();
    DailyEntry? entry;
    if (data != null && data?.last != null) {
      entry = instance.getDailyEntry(DateTimeUtils.epochDays(data!.last!));
    }
    List<Color> badgeColors = <Color>[];
    if (entry?.secured ?? false) {
      badgeColors.add(Palette.orange[500]!);
    }
    if ((entry?.current ?? 0) > 1) {
      badgeColors.add(Palette.red[500]!);
    }
    if ((entry?.points ?? 0) > 1) {
      badgeColors.add(Palette.pink[500]!);
    }
    if ((entry?.pallor ?? 0) > 1) {
      badgeColors.add(Palette.purple[500]!);
    }
    if ((entry?.tags?.length ?? 0) > 0) {
      badgeColors.add(Palette.green[500]!);
    }
    if (entry?.notes?.isNotEmpty ?? false) {
      badgeColors.add(Palette.blue[500]!);
    }

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            entry != null ? activeColors.first : inactiveColors.first,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15))),
      ),
      onPressed: () {
        context.pushNamed("/entry", pathParameters: <String, String>{
          "epochDate":
              "${entry?.epochDate ?? (data?.last != null ? DateTimeUtils.epochDays(data!.last!) : -1)}"
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
                    color:
                        entry != null ? activeColors.last : inactiveColors.last,
                    width: 2),
              ),
            ),
            child: Text(
              data?.first ?? "--",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          const Spacer(),
          if (badgeColors.isNotEmpty)
            MoonbaseBadgeSection(badgeColors: badgeColors),
        ],
      ),
    );
  }
}
