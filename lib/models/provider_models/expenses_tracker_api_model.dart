import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';

/// Model for Expenses tracker used in Provider
class ExpensesTrackerApiModel extends ChangeNotifier {
  final ExpensesTrackerApi _expensesTrackerApi = ExpensesTrackerApi();

  /// Getter for expensesTrackerApi
  ExpensesTrackerApi get expensesTrackerApi => _expensesTrackerApi;
}
