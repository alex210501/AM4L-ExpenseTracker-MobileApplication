import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';

/// Setting screen
class SettingsScreen extends StatelessWidget {
  /// Constructor
  const SettingsScreen({super.key});

  /// On changed switch for dark theme
  void _onChangedDarkTheme(BuildContext context) {
    // Get selection theme
    final themeSelection = getThemeSelection(context);

    // Toggle the value
    themeSelection.toggle();
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
              const Text(
                'Dark theme',
                style: TextStyle(fontSize: 15.0),
              ),
              Switch(value: isDarkTheme, onChanged: (_) => _onChangedDarkTheme(context))
            ],
          ),
        ]),
      ),
    );
  }
}
