// ignore_for_file: file_names
import 'package:flutter/material.dart';

class MoonbaseBadgeSection extends StatelessWidget {
  final List<Color>? badgeColors;
  final List<double>? sizes;

  const MoonbaseBadgeSection({super.key, this.badgeColors, this.sizes});

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
    List<double> finalSizes = sizes ?? [0, 7, 7, 7];
    double size = finalSizes[1];
    size = finalSizes[badgeColors!.length];

    return Column(children: getBadgeRows(badgeColors ?? [], null, size));
  }
}
