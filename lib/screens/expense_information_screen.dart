import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/categories_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/general_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/edit_expense_modal.dart';

class ExpenseInformationScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  ExpenseInformationScreen({super.key, required this.expensesTrackerApi});

  @override
  State<ExpenseInformationScreen> createState() => _ExpenseInformationScreenState();
}

class _ExpenseInformationScreenState extends State<ExpenseInformationScreen> {
  String _spaceId = '';
  String _expenseId = '';
  Space _space = Space.defaultValue();
  Expense _expense = Expense.defaultValues();

  void _loadFromArguments(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    // Set expense and space ID
    _spaceId = arguments['spaceId'] ?? '';
    _expenseId = arguments['expenseId'] ?? '';

    // Load expense
    _space = Provider.of<SpacesListModel>(context, listen: false).getSpaceByID(_spaceId)!;
    _expense = Provider.of<ExpensesListModel>(context, listen: false).getExpenseByID(_expenseId)!;
  }

  void _onEdit(BuildContext context) async {
    // Get the new expense
    final updatedExpense = await showEditExpenseModal(
        context,
        _space,
        widget.expensesTrackerApi,
        expenseId: _expenseId,
    );

    // If the expense is not null, we can update the current one
    if (updatedExpense != null) {
      setState(() {
        _expense = updatedExpense;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Load arguments passed to the route
    _loadFromArguments(context);

    // Take the category of the expense
    final category = Provider.of<CategoriesListModel>(context, listen: false)
        .getCategoryById(_expense.category ?? '');

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
              Text('Date: ${formatDate(_expense.date)}'),
              Text('Category: ${category?.title ?? 'None'}'),
            ],
          ),
        ),
      );
    });
  }
}
