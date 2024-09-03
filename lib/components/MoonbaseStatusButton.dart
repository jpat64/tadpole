// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MoonbaseStatusButtonBar extends StatelessWidget {
  final void Function(int) onPressedCallback;
  final int initialValue;
  final Color zeroColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color dividerColor;
  final bool editingMode;

  const MoonbaseStatusButtonBar({
    super.key,
    required this.onPressedCallback,
    required this.initialValue,
    required this.zeroColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.dividerColor,
    required this.editingMode,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        MoonbaseStatusButton(
          currentLevel: initialValue,
          targetLevel: 0,
          zeroColor: zeroColor,
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
          zeroColor: zeroColor,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onPressedCallback: () {
            if (editingMode) {
              onPressedCallback(1);
            }
          },
        ),
        const SizedBox(width: 8),
        VerticalDivider(color: dividerColor, width: 2),
        MoonbaseStatusButton(
          currentLevel: initialValue,
          targetLevel: 2,
          zeroColor: zeroColor,
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
          zeroColor: zeroColor,
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
          zeroColor: zeroColor,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onPressedCallback: () {
            if (editingMode) {
              onPressedCallback(4);
            }
          },
        ),
      ]),
    );
  }
}

class MoonbaseStatusButton extends StatelessWidget {
  final int currentLevel;
  final int targetLevel;
  final Color zeroColor;
  final Color activeColor;
  final Color inactiveColor;
  final void Function() onPressedCallback;

  const MoonbaseStatusButton({
    super.key,
    required this.currentLevel,
    required this.targetLevel,
    required this.zeroColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    double sizeFactor = 6;
    return Container(
        padding: const EdgeInsets.only(left: 8),
        child: InkWell(
            onTap: onPressedCallback,
            child: Badge(
              backgroundColor: (targetLevel == 0)
                  ? zeroColor
                  : (currentLevel >= targetLevel)
                      ? activeColor
                      : inactiveColor,
              smallSize: (targetLevel == 0 ? 4 : targetLevel) * sizeFactor,
            )));
  }
}
