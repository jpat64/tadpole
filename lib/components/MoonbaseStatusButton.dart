// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseStatusButton extends StatelessWidget {
  final int currentLevel;
  final int targetLevel;
  final Color activeColor;
  final Color inactiveColor;
  final void Function() onPressedCallback;

  const MoonbaseStatusButton({
    super.key,
    required this.currentLevel,
    required this.targetLevel,
    required this.activeColor,
    required this.inactiveColor,
    required this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    double sizeFactor = 6;
    return InkWell(
        onTap: onPressedCallback,
        child: Badge(
          backgroundColor: (targetLevel == 0)
              ? Palette.tan[50]!
              : (currentLevel >= targetLevel)
                  ? activeColor
                  : inactiveColor,
          smallSize: (targetLevel == 0 ? 4 : targetLevel) * sizeFactor,
        ));
  }
}
