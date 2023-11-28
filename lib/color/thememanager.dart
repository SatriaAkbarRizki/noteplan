import 'package:flutter/material.dart';
import 'package:noteplan/local/modeUser.dart';

class ThemeManager {
  ModeUser modeUser = ModeUser();

  static final ValueNotifier<ThemeMode> valueNotifierTheme =
      ValueNotifier(ThemeMode.light);

  Future setThemeMode(bool isDark) async {
    await modeUser.saveModeUser(
        isDark ? ThemeMode.dark.toString() : ThemeMode.light.toString());

    valueNotifierTheme.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
