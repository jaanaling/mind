import 'package:flutter/material.dart';

final class _CoreThemeColors {
  final Color unActiveIconColor = const Color(0xFFAEAEAE);
  final Color activeIconColor = Colors.white;
  final Color bottomBarBackgroundColor = Colors.black;
  final Color webViewColor = Colors.transparent;
}

class CoreTheme {
  static final _CoreThemeColors color = _CoreThemeColors();
}
