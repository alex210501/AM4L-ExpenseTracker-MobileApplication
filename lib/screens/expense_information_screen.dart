import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/general_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/edit_expense_modal.dart';

class ExpenseInformationScreen extends StatefulWidget {
  /// Constructor
  const ExpenseInformationScreen({super.key});

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
    _space = getSpacesListModel(context).getSpaceByID(_spaceId)!;
    _expense = getExpensesListModel(context).getExpenseByID(_expenseId)!;
  }

  void _onEdit(BuildContext context) async {
    // Get the new expense from the modal output
    final updatedExpense = await showEditExpenseModal(
      context,
      _space,
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
    final category = getCategoriesListModel(context).getCategoryById(_expense.category ?? '');

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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InformationLine(title: 'Description', info: _expense.description),
              _InformationLine(title: 'Cost', info: '${_expense.cost} €'),
              _InformationLine(title: 'Author', info: _expense.paidBy),
              _InformationLine(title: 'Date', info: formatDate(_expense.date)),
              _InformationLine(title: 'Category', info: category?.title ?? 'None'),
            ],
          ),
        ),
      );
    });
  }
}

class _InformationLine extends StatelessWidget {
  final String title;
  final String info;

  /// Constructor
  const _InformationLine({super.key, required this.title, required this.info});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 15.0),
        children: [
          TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ': $info'),
        ],
      ),
    );
  }
}
