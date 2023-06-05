import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/provider_models/categories_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/credentials_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/theme_selection.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/create_user_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/expenses_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/expense_information_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/login_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/space_information_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/spaces_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/qrcode_scanner_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/settings_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ExpensesTrackerApi expensesTrackerApi = ExpensesTrackerApi();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CategoriesListModel()),
          ChangeNotifierProvider(create: (context) => CredentialsModel()),
          ChangeNotifierProvider(create: (context) => ExpensesListModel()),
          ChangeNotifierProvider(create: (context) => SpacesListModel()),
          ChangeNotifierProvider(create: (context) => ThemeSelection()),
        ],
        child: Consumer<ThemeSelection>(
          builder: (context, ThemeSelection themeSelection, child) {
            return MaterialApp(
                title: 'Expense Tracker',
                theme: themeSelection.isDarkTheme
                    ? ThemeData.dark()
                    : ThemeData(
                        primarySwatch: Colors.blue,
                      ),
                initialRoute: '/login',
                routes: {
                  '/login': (context) => LoginScreen(expensesTrackerApi: expensesTrackerApi),
                  '/create-user': (context) =>
                      CreateUserScreen(expensesTrackerApi: expensesTrackerApi),
                  '/space': (context) => SpacesScreen(expensesTrackerApi: expensesTrackerApi),
                  '/space/info': (context) =>
                      SpaceInformationScreen(expensesTrackerApi: expensesTrackerApi),
                  '/space/expenses': (context) =>
                      ExpensesScreen(expensesTrackerApi: expensesTrackerApi),
                  '/space/expense/info': (context) =>
                      ExpenseInformationScreen(expensesTrackerApi: expensesTrackerApi),
                  '/space/qrcode': (context) => QrCodeScannerScreen(),
                  '/settings': (context) => SettingsScreen(),
                });
          },
        ));
  }
}
