import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/screens/create_user_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/expenses_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/login_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/space_information_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/screens/spaces_screen.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/services/data_service.dart';


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
    return ChangeNotifierProvider(
        create: (context) => DataService(),
        child: MaterialApp(
          title: 'Expense Tracker',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) =>
                LoginScreen(expensesTrackerApi: expensesTrackerApi),
            '/create-user': (context) =>
                CreateUserScreen(expensesTrackerApi: expensesTrackerApi),
            '/space': (context) =>
                SpacesScreen(expensesTrackerApi: expensesTrackerApi),
            '/space/info': (context) =>
                SpaceInformationScreen(expensesTrackerApi: expensesTrackerApi),
            '/space/expenses': (context) =>
                ExpensesScreen(expensesTrackerApi: expensesTrackerApi),
          })
    );
  }
}
