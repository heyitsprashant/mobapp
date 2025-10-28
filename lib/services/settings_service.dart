import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class SettingsService {
  SettingsService(this._preferences);

  final SharedPreferences _preferences;

  ThemeMode loadThemeMode() {
    final index = _preferences.getInt(kThemeModePrefKey);
    if (index == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values[index];
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _preferences.setInt(kThemeModePrefKey, themeMode.index);
  }

  Future<void> updateNotificationPreference(bool enabled) async {
    await _preferences.setBool(kNotificationEnabledPrefKey, enabled);
  }
}
