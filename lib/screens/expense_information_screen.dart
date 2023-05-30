import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/edit_expense_modal.dart';

class ExpenseInformationScreen extends StatelessWidget {
  final ExpensesTrackerApi expensesTrackerApi;
  String _spaceId = '';
  String _expenseId = '';
  Space _space = Space.defaultValue();
  Expense _expense = Expense.defaultValues();

  ExpenseInformationScreen({super.key, required this.expensesTrackerApi});

  void _loadFromArguments(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    // Set expense and space ID
    _spaceId = arguments['spaceId'] ?? '';
    _expenseId = arguments['expenseId'] ?? '';

    // Load expense
    _space = Provider.of<SpacesListModel>(context, listen: false).getSpaceByID(_spaceId)!;
    _expense = Provider.of<ExpensesListModel>(context, listen: false).getExpenseByID(_expenseId)!;
  }

  void _onEdit(BuildContext context) {
    showEditExpenseModal(context, _space, expensesTrackerApi, expenseId: _expenseId);
  }

  @override
  Widget build(BuildContext context) {
    _loadFromArguments(context);

    return Consumer<ExpensesListModel>(builder: (context, card, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_expense.description),
          actions: [
            IconButton(
              onPressed: () => _onEdit(context),
              icon: const Icon(Icons.edit),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Text('Description: ${_expense.description}'),
              Text('Cost: ${_expense.cost}€'),
              Text('Author: ${_expense.paidBy}'),
              Text('Date: ${_expense.date}'),
              Text('Category: ${_expense.category}'),
            ],
          ),
        ),
      );
    });
  }
}
