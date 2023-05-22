import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expenses_list.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/services/data_service.dart';

class ExpensesScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  const ExpensesScreen({super.key, required this.expensesTrackerApi});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  Space _space = Space.defaultValue();

  Future<List<Expense>> _getExpenses() async {
    return await widget.expensesTrackerApi.expenseApi.getExpenses(_space.id);
  }

  void _showEditExpenseModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return _ExpenseForm(
            expensesTrackerApi: widget.expensesTrackerApi,
            spaceId: _space.id,
          );
        });
  }

  void _onDeleteExpense(BuildContext context, Expense expense) {
    widget.expensesTrackerApi.expenseApi.deleteExpense(_space.id, expense.id)
        .then((_) => Provider.of<ExpensesList>(context).removeExpenseByID(expense.id));
  }

  @override
  Widget build(BuildContext context) {
    final expensesList = Provider.of<ExpensesList>(context);
    final spaceArg = ModalRoute.of(context)!.settings.arguments;

    // Check if the space is passed as parameters, if not then return to the last screen
    if (spaceArg == null) {
      Navigator.pop(context);
    } else {
      _space = spaceArg as Space;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_space.name),
      ),
      floatingActionButton: IconButton(
        onPressed: () => _showEditExpenseModal(context),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Expense>>(
        future: _getExpenses(),
        builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            expensesList.setExpenses(snapshot.data ?? [], notify: false);

            return Consumer<ExpensesList>(builder: (context, card, child) {
              return _ExpenseListView(onDelete: _onDeleteExpense,);
            });
          }

          return const Center(child: Text('Empty Data'));
        },
      ),
    );
  }
}

class _ExpenseListView extends StatelessWidget {
  final void Function(BuildContext, Expense) onDelete;

  const _ExpenseListView({ required this.onDelete });

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpensesList>(context).expenses;

    return Center(
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: ValueKey<Expense>(expenses[index]),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (_) => onDelete(context, expenses[index]),
              child: Card(
                child: ListTile(
                  title: Text(expenses[index].description),
                  subtitle: Text('Paid by ${expenses[index].paidBy}'),
                  trailing: Text('${expenses[index].cost}€'),
                ),
              ));
        },
      ),
    );
  }
}

class _ExpenseForm extends StatefulWidget {
  final expensesTrackerApi;
  final String spaceId;
  final String? expenseId;

  const _ExpenseForm({
    required this.expensesTrackerApi,
    required this.spaceId,
    this.expenseId,
  });

  @override
  State<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<_ExpenseForm> {
  bool _firstBuild = true;
  bool _isNewExpense = false;
  Expense _expense = Expense.defaultValues();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  /// Save the expense to the API
  void _onSave(BuildContext context) {
    // Get DataService from the context
    DataService dataService = Provider.of<DataService>(context, listen: false);

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
        Provider.of<ExpensesList>(context, listen: false).addExpense(newExpense);
        Navigator.pop(context);
      });
    }
  }

  /// Load expense from ExpensesList
  void _loadExpense(BuildContext context) {
    // Check if the expense is a new one or you must update an existing one
    if (widget.expenseId == null) {
      _expense = Expense.defaultValues();
      _isNewExpense = true;
    } else {
      // TODO: Show an error if the requested expense is not on the list
      _expense = Provider.of<ExpensesList>(context).getExpenseByID(widget.expenseId!) ??
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
