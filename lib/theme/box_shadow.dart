import 'package:flutter/material.dart';

List<BoxShadow> box_shadow(BuildContext context) {
  ThemeData theme = Theme.of(context);

  return [
    BoxShadow(
        color: theme.colorScheme.onSurface.withOpacity(0.2),
        offset: const Offset(2, 2),
        blurRadius: 9,
        spreadRadius: 1.7),
    // const BoxShadow(
    //     color: Colors.white70,
    //     offset: Offset(-2, -2),
    //     blurRadius: 10,
    //     spreadRadius: 1)
  ];
}
