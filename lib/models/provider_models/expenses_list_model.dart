import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';

/// Expenses list model used in Provider
class ExpensesListModel extends ChangeNotifier {
  List<Expense> _expenses = [];

  /// Getter for the expenses
  List<Expense> get expenses => UnmodifiableListView(_expenses);

  /// Set new expenses
  void setExpenses(List<Expense> newExpenses, {bool notify = true}) {
    _expenses = List.from(newExpenses);

    if (notify) {
      notifyListeners();
    }
  }

  /// Clear expenses
  void clearExpenses() {
    _expenses.clear();
  }

  /// Add a new expense to the list
  void addExpense(Expense newExpense, {bool notify = true}) {
    _expenses.insert(0, newExpense);

    if (notify) {
      notifyListeners();
    }
  }

  /// Remove an expense given it [expenseId]
  void removeExpenseByID(String expenseId, {bool notify = true}) {
    _expenses.removeWhere((expense) => expense.id == expenseId);

    if (notify) {
      notifyListeners();
    }
  }

  /// Get expense by ID
  Expense? getExpenseByID(String expenseId) {
    return _expenses.firstWhere((expense) => expense.id == expenseId);
  }

  /// Update an expense
  void updateExpense(Expense newExpense, {bool notify = true}) {
    _expenses.forEach((expense) {
      if (expense.id == newExpense.id) {
        expense.description = newExpense.description;
        expense.cost = newExpense.cost;
        expense.category = newExpense.category;
      }
    });

    if (notify) {
      notifyListeners();
    }
  }
}
