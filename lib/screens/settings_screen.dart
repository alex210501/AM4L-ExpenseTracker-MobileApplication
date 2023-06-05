import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/preference_tools.dart';

/// Show the settings
class SettingsScreen extends StatefulWidget {
  /// Constructor
  const SettingsScreen({super.key});

  /// Override createState
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

/// State for [SettingsScreen]
class _SettingsScreenState extends State<SettingsScreen> {
  /// On changed switch for dark theme
  void _onChangedDarkTheme(BuildContext context) {
    setState(() {
      // Get selection theme
      final themeSelection = getThemeSelection(context);

      // Toggle the value
      themeSelection.toggle();

      // Memorize the theme in preferences
      setDarkThemePref(themeSelection.isDarkTheme);
    });
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final isDarkTheme = getThemeSelection(context).isDarkTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dark theme', style: TextStyle(fontSize: 15.0)),
              Switch(value: isDarkTheme, onChanged: (_) => _onChangedDarkTheme(context))
            ],
          ),
        ]),
      ),
    );
  }
}
