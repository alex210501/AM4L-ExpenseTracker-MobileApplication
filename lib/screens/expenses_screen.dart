import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/edit_expense_modal.dart';


class ExpensesScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  const ExpensesScreen({super.key, required this.expensesTrackerApi});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  Space _space = Space.defaultValue();

  void _onDeleteExpense(BuildContext context, Expense expense) {
    widget.expensesTrackerApi.expenseApi.deleteExpense(_space.id, expense.id)
        .then((_) => Provider.of<ExpensesListModel>(context).removeExpenseByID(expense.id));
  }

  @override
  Widget build(BuildContext context) {
    final expensesList = Provider.of<ExpensesListModel>(context);
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
        onPressed: () => showEditExpenseModal(context, _space, widget.expensesTrackerApi),
        icon: const Icon(Icons.add),
      ),
      body: Consumer<ExpensesListModel>(builder: (context, card, child) {
        return _ExpenseListView(spaceId: _space.id, onDelete: _onDeleteExpense,);
      }),
    );
  }
}

class _ExpenseListView extends StatelessWidget {
  final spaceId;
  final void Function(BuildContext, Expense) onDelete;

  const _ExpenseListView({ required this.spaceId, required this.onDelete });

  void _onExpense(BuildContext context, Expense expense) {
    Map<String, String> arguments = {
      'spaceId': spaceId,
      'expenseId': expense.id,
    };

    Navigator.pushNamed(context, '/space/expense/info', arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpensesListModel>(context).expenses;

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
                  onTap: () => _onExpense(context, expenses[index]),
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