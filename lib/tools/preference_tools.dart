import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

const darkThemeKey = 'darkTheme';

/// Get instance to [SharedPreferences]
Future<SharedPreferences> get _getSharedPreferences async => await SharedPreferences.getInstance();

/// Get if we are using DarkTheme
Future<bool> isDarkThemePref() async {
  final prefs = await _getSharedPreferences;

  /// Get the dark theme config
  return prefs.getBool(darkThemeKey) ?? false;
}

/// Set the [isDarkTheme] preferences
Future<void> setDarkThemePref(bool isDarkTheme) async {
  final prefs = await _getSharedPreferences;

  // Set the dark theme
  prefs.setBool(darkThemeKey, isDarkTheme);
}
