// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moonbase/utils/Palette.dart';

class MoonbaseStatusButtonBar extends StatelessWidget {
  final void Function(int) onPressedCallback;
  final int initialValue;
  final Color activeColor;
  final Color inactiveColor;
  final bool editingMode;

  const MoonbaseStatusButtonBar({
    super.key,
    required this.onPressedCallback,
    required this.initialValue,
    required this.activeColor,
    required this.inactiveColor,
    required this.editingMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      MoonbaseStatusButton(
        currentLevel: initialValue,
        targetLevel: 0,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onPressedCallback: () {
          if (editingMode) {
            onPressedCallback(0);
          }
        },
      ),
      MoonbaseStatusButton(
        currentLevel: initialValue,
        targetLevel: 1,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onPressedCallback: () {
          if (editingMode) {
            onPressedCallback(1);
          }
        },
      ),
      MoonbaseStatusButton(
        currentLevel: initialValue,
        targetLevel: 2,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onPressedCallback: () {
          if (editingMode) {
            onPressedCallback(2);
          }
        },
      ),
      MoonbaseStatusButton(
        currentLevel: initialValue,
        targetLevel: 3,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onPressedCallback: () {
          if (editingMode) {
            onPressedCallback(3);
          }
        },
      ),
      MoonbaseStatusButton(
        currentLevel: initialValue,
        targetLevel: 4,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onPressedCallback: () {
          if (editingMode) {
            onPressedCallback(4);
          }
        },
      ),
    ]);
  }
}

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
