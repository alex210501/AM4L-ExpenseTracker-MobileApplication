import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/edit_expense_modal.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/error_dialog.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/qrcode.dart';

/// Screen to show the expense of a [Space]
class ExpensesScreen extends StatefulWidget {
  /// Constructor
  const ExpensesScreen({super.key});

  /// Override createState
  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

/// State for ExpensesScreen
class _ExpensesScreenState extends State<ExpensesScreen> {
  late ExpensesTrackerApi _expensesTrackerApi;
  bool _showQrCode = false; // Is the QR code displayed
  Space _space = Space.defaultValue();

  /// Callback used when we want to refresh the expenses
  Future<void> _onRefresh(BuildContext context) async {
    /// Load expenses from the context
    final expensesListModel = getExpensesListModel(context);

    try {
      // Get expenses from API
      final expenses = await _expensesTrackerApi.expenseApi.getExpenses(_space.id);

      // Refresh expenses
      expensesListModel.setExpenses(expenses);
    } on Exception catch (e) {
      showErrorDialog(context, e);
    }
  }

  /// Callback to delete an [expense] from the [Space]
  void _onDeleteExpense(BuildContext context, Expense expense) {
    /// Make request to delete expense
    _expensesTrackerApi.expenseApi
        .deleteExpense(_space.id, expense.id)
        .then((_) => getExpensesListModel(context).removeExpenseByID(expense.id))
        .catchError((err) => showErrorDialog(context, err));
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    final spaceArg = ModalRoute.of(context)!.settings.arguments;

    // Get ExpensesTrackerApi from context
    _expensesTrackerApi = getExpensesTrackerApiModel(context).expensesTrackerApi;

    // Check if the space is passed as parameters, if not then return to the last screen
    if (spaceArg == null) {
      Navigator.pop(context);
    } else {
      _space = spaceArg as Space;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_space.name),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showQrCode = true),
            icon: const Icon(Icons.qr_code_rounded, color: Colors.white),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<ExpensesListModel>(builder: (context, card, child) {
        return ExpensesBottomAppBar();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEditExpenseModal(context, _space),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Consumer<ExpensesListModel>(builder: (context, card, child) {
                return _ExpenseListView(spaceId: _space.id, onDelete: _onDeleteExpense);
              }),
              if (_showQrCode)
                QrCode(
                  qrCodeMessage: _space.id,
                  onPressed: (_) => setState(() => _showQrCode = false),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget to show the expenses using a [ListView]
class _ExpenseListView extends StatelessWidget {
  final String spaceId;
  final void Function(BuildContext, Expense) onDelete;

  /// Constructor
  const _ExpenseListView({required this.spaceId, required this.onDelete});

  /// Callback used when you click on an [expense]
  void _onExpense(BuildContext context, Expense expense) {
    Map<String, String> arguments = {
      'spaceId': spaceId,
      'expenseId': expense.id,
    };

    // Go display the information of the expense
    Navigator.pushNamed(context, '/space/expense/info', arguments: arguments);
  }

  /// Get the title to display who paid this [expense]
  Widget _getPaidByTitle(BuildContext context, Expense expense) {
    final username = getCredentialsModel(context).username;

    return Row(
      children: [
        const Text('Paid by '),
        Text(
          expense.paidBy == username ? 'You' : expense.paidBy,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    final expenses = getExpensesListModel(context).expenses;

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
                subtitle: _getPaidByTitle(context, expenses[index]),
                trailing: Text('${expenses[index].cost}€'),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Bottom bar that display the information about the your total cost
/// and the total cost of the entire expenses
class ExpensesBottomAppBar extends StatelessWidget {
  /// Constructor
  const ExpensesBottomAppBar({super.key});

  /// Compute the total expenses
  double _getTotalExpenses(List<Expense> expenses, {String? username}) {
    double sum = 0.0;

    // Compute sum for each expense
    for (var element in expenses) {
      if ((username == null) || (username == element.paidBy)) {
        sum += element.cost;
      }
    }

    return sum;
  }

  /// Compute the total expenses of the current user
  double _getTotalUserExpenses(BuildContext context, List<Expense> expenses) {
    final username = getCredentialsModel(context).username;

    return _getTotalExpenses(expenses, username: username);
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    final expenses = getExpensesListModel(context).expenses;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TotalExpensesColumn(
            title: 'Your expenses',
            expenses: _getTotalUserExpenses(context, expenses),
          ),
          _TotalExpensesColumn(
            title: 'Total expenses',
            expenses: _getTotalExpenses(expenses),
          ),
        ],
      ),
    );
  }
}

/// Class that display the total expenses columns
class _TotalExpensesColumn extends StatelessWidget {
  final double heightSizedBox = 50.0;
  final String title;
  final double expenses;

  /// Constructor
  const _TotalExpensesColumn({required this.title, required this.expenses});

  /// Override build
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightSizedBox,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('$expenses €'),
        ],
      ),
    );
  }
}
