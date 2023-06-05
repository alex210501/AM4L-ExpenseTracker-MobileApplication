import 'package:am4l_expensetracker_mobileapplication/models/theme_selection.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

/// Setting screen
class SettingsScreen extends StatelessWidget {
  /// On changed switch for dark theme
  void _onChangedDarkTheme(BuildContext context) {
    // Get selection theme
    final themeSelection = Provider.of<ThemeSelection>(context, listen: false);

    // Toggle the value
    themeSelection.toggle();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final isDarkTheme = Provider.of<ThemeSelection>(context, listen: false).isDarkTheme;

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