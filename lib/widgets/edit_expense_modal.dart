import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/models/spaces_list_model.dart';

void showEditExpenseModal(
    BuildContext context,
    Space space,
    ExpensesTrackerApi expensesTrackerApi,
    { String? expenseId }
    ) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ExpenseForm(
          expensesTrackerApi: expensesTrackerApi,
          spaceId: space.id,
          expenseId: expenseId,
        );
      });
}

class ExpenseForm extends StatefulWidget {
  final expensesTrackerApi;
  final String spaceId;
  final String? expenseId;

  const ExpenseForm({
    required this.expensesTrackerApi,
    required this.spaceId,
    this.expenseId,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  bool _firstBuild = true;
  bool _isNewExpense = false;
  Expense _expense = Expense.defaultValues();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  /// Save the expense to the API
  void _onSave(BuildContext context) {
    // Get SpacesListModel from the context
    SpacesListModel dataService = Provider.of<SpacesListModel>(context, listen: false);

    // Take the values from the controllers
    _expense.cost = double.parse(_costController.text);
    _expense.description = _descriptionController.text;

    // If the expense is new then create it, otherwise you update it
    if (_isNewExpense) {
      // Set the date to now
      _expense.date = DateTime.now().toString();

      widget.expensesTrackerApi.expenseApi
          .createExpense(widget.spaceId, _expense)
          .then((newExpense) {
            Provider.of<ExpensesListModel>(context, listen: false).addExpense(newExpense);
            Navigator.pop(context);
          });
    } else {
      widget.expensesTrackerApi.expenseApi
          .patchExpense(widget.spaceId, _expense)
          .then((_) {
            Provider.of<ExpensesListModel>(context, listen: false).updateExpense(_expense);
            Navigator.pop(context);
          });
    }
  }

  /// Load expense from ExpensesListModel
  void _loadExpense(BuildContext context) {
    // Check if the expense is a new one or you must update an existing one
    if (widget.expenseId == null) {
      _expense = Expense.defaultValues();
      _isNewExpense = true;
    } else {
      // TODO: Show an error if the requested expense is not on the list
      _expense = Provider.of<ExpensesListModel>(context).getExpenseByID(widget.expenseId!) ??
          Expense.defaultValues();
    }

    // Set the text from the TextEditingController
    _descriptionController.text = _expense.description;
    _costController.text = _expense.cost.toString();
  }

  /// Dispose the widget
  @override
  void dispose() {
    // Clear resources used by TextEditingController
    _descriptionController.dispose();
    _costController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_firstBuild) {
      _firstBuild = false;
      _loadExpense(context);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _isNewExpense ? 'New expense' : _expense.description,
          ),
          leading: TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: () => _onSave(context),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: "Expense description"),
                validator: (text) {
                  return (text == null || text.isEmpty) ? "Description cannot be empty!" : null;
                },
              ),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Cost"),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
