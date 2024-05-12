// ignore_for_file: file_names
import 'package:flutter/material.dart';

class MoonbaseBadgeSection extends StatelessWidget {
  final List<Color>? badgeColors;

  const MoonbaseBadgeSection({super.key, this.badgeColors});

  List<Row> getBadgeRows(List<Color> badgeColors, List<Row>? toReturn) {
    toReturn ??= <Row>[];
    if (badgeColors.length <= 3) {
      toReturn.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: badgeColors
              .map<Container>((element) => Container(
                  padding: const EdgeInsets.all(1),
                  child: Badge(
                    smallSize: 7,
                    backgroundColor: element,
                  )))
              .toList()));
      return toReturn;
    } else if (badgeColors.length == 4) {
      toReturn = getBadgeRows(badgeColors.sublist(0, 2), toReturn);
      toReturn = getBadgeRows(badgeColors.sublist(2, 4), toReturn);
      return toReturn;
    } else {
      toReturn = getBadgeRows(badgeColors.sublist(0, 3), toReturn);
      toReturn = getBadgeRows(badgeColors.sublist(3), toReturn);
      return toReturn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: getBadgeRows(badgeColors ?? [], null));
  }
}
