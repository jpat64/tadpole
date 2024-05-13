// ignore_for_file: file_names
import 'package:flutter/material.dart';

class MoonbaseBadgeSection extends StatelessWidget {
  final List<Color>? badgeColors;

  const MoonbaseBadgeSection({super.key, this.badgeColors});

  static const List<double> sizes = [0, 8, 7, 6];

  List<Row> getBadgeRows(
      List<Color> badgeColors, List<Row>? toReturn, double size) {
    toReturn ??= <Row>[];
    if (badgeColors.length <= 3) {
      toReturn.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: badgeColors
              .map<Container>((element) => Container(
                  padding: const EdgeInsets.all(1),
                  child: Badge(
                    smallSize: size,
                    backgroundColor: element,
                  )))
              .toList()));
      return toReturn;
    } else if (badgeColors.length == 4) {
      toReturn = getBadgeRows(badgeColors.sublist(0, 2), toReturn, size);
      toReturn = getBadgeRows(badgeColors.sublist(2, 4), toReturn, size);
      return toReturn;
    } else {
      toReturn = getBadgeRows(badgeColors.sublist(0, 3), toReturn, size);
      toReturn = getBadgeRows(badgeColors.sublist(3), toReturn, size);
      return toReturn;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = sizes[3];
    if ((badgeColors?.length ?? 0) < 4) {
      size = sizes[badgeColors!.length];
    }
    if ((badgeColors?.length ?? 0) == 4) {
      size = sizes[2];
    }
    return Column(children: getBadgeRows(badgeColors ?? [], null, size));
  }
}
