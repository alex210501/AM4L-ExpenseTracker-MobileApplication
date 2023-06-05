import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/tools/preference_tools.dart';

/// Store the current theme
class ThemeSelection extends ChangeNotifier {
  bool _isDarkTheme = false;

  /// Constructor
  ///
  /// Load the theme from the preferences
  ThemeSelection() {
    isDarkThemePref().then((res) => isDarkTheme = res);
  }

  /// Getter for [isDarkTheme]
  bool get isDarkTheme => _isDarkTheme;

  /// Setter for [isDarkTheme]
  set isDarkTheme(bool value) {
    _isDarkTheme = value;

    notifyListeners();
  }

  /// Toggle the theme
  void toggle() {
    _isDarkTheme = !_isDarkTheme;

    notifyListeners();
  }
}
