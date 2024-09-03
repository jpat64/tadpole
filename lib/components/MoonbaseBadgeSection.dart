// ignore_for_file: file_names
import 'package:flutter/material.dart';

class MoonbaseBadgeSection extends StatelessWidget {
  final List<Color>? badgeColors;

  const MoonbaseBadgeSection({super.key, this.badgeColors});

  static const List<double> sizes = [0, 7, 7, 7];

  List<Row> getBadgeRows(
      List<Color> badgeColors, List<Row>? toReturn, double size) {
    toReturn ??= <Row>[];
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
  }

  @override
  Widget build(BuildContext context) {
    double size = sizes[1];
    size = sizes[badgeColors!.length];

    return Column(children: getBadgeRows(badgeColors ?? [], null, size));
  }
}
