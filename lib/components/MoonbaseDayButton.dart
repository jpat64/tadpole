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
  final Palette palette;
  final Pair<String, DateTime?>? data;

  const MoonbaseDayButton(
      {super.key, required this.palette, required this.data});

  @override
  Widget build(BuildContext context) {
    DatabaseService instance = DatabaseService.instance;
    DailyEntry? entry;
    if (data != null && data?.last != null) {
      entry = instance.getDailyEntry(DateTimeUtils.epochDays(data!.last!));
    }
    List<Color> badgeColors = <Color>[];
    if (entry?.secured ?? false) {
      badgeColors.add(palette.accent);
    }
    if ((entry?.current ?? 0) > 1 ||
        (entry?.points ?? 0) > 1 ||
        (entry?.pallor ?? 0) > 1) {
      badgeColors.add(palette.splash);
    }
    if ((entry?.tags?.isNotEmpty ?? false) ||
        (entry?.notes?.isNotEmpty ?? false)) {
      badgeColors.add(palette.primary);
    }

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: entry != null ? palette.secondary : palette.background,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: entry != null ? palette.secondary : palette.off),
            borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(15))),
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
                    color: entry != null ? palette.primary : palette.disabled,
                    width: 2),
              ),
            ),
            child: Text(
              data?.first ?? "--",
              style: TextStyle(fontSize: 16, color: palette.text),
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
