import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';

class ExpensesScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  const ExpensesScreen({super.key, required this.expensesTrackerApi});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late final Space _space;

  Future<List<Expense>> _getExpenses() async {
    return await widget.expensesTrackerApi.expenseApi.getExpenses(_space.id);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Expense>>(
        future: _getExpenses(),
        builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return _ExpenseListView(
              expenses: snapshot.data ?? [],
            );
          }

          return const Center(child: Text('Empty Data'));
        },
      ),
    );
  }
}

class _ExpenseListView extends StatelessWidget {
  List<Expense> expenses;

  _ExpenseListView({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(expenses[index].description),
                subtitle: Text('Paid by ${expenses[index].paidBy}'),
                trailing: Text('${expenses[index].cost}€'),
              ),
            );
          },
      ),
    );
  }
}