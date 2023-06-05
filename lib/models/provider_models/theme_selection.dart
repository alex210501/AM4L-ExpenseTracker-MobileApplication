import 'package:flutter/material.dart';

/// Store the current theme
class ThemeSelection extends ChangeNotifier {
  bool _isDarkTheme = false;

  /// Getter for isDarkTheme
  bool get isDarkTheme => _isDarkTheme;

  /// Toggle the theme
  void toggle() {
    _isDarkTheme = !_isDarkTheme;

    notifyListeners();
  }
}
