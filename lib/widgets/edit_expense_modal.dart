import 'package:am4l_expensetracker_mobileapplication/models/categories_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/category.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/general_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/api_loading_indicator.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/floatnumber_formfield.dart';

Future<Expense?> showEditExpenseModal(
    BuildContext context, Space space, ExpensesTrackerApi expensesTrackerApi,
    {String? expenseId}) {
  return showModalBottomSheet(
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
  final ExpensesTrackerApi expensesTrackerApi;
  final String spaceId;
  final String? expenseId;

  const ExpenseForm({
    super.key,
    required this.expensesTrackerApi,
    required this.spaceId,
    this.expenseId,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  bool _isLoading = false;
  bool _firstBuild = true;
  bool _isNewExpense = false;
  Category? _category;
  Expense _expense = Expense.defaultValues();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  void _setLoading(bool loadingMode) {
    setState(() {
      _isLoading = loadingMode;
    });
  }

  /// Save the expense to the API
  void _onSave(BuildContext context) {
    // Check if the form is valid, return if its not
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get SpacesListModel from the context
    SpacesListModel dataService = Provider.of<SpacesListModel>(context, listen: false);

    // Take the values from the controllers
    _expense.cost = roundDoubleToDecimals(double.parse(_costController.text));
    _expense.description = _descriptionController.text;
    _expense.category = _category?.id;

    // Start loading
    _setLoading(true);

    // If the expense is new then create it, otherwise you update it
    if (_isNewExpense) {
      // Set the date to now
      _expense.date = DateTime.now();

      widget.expensesTrackerApi.expenseApi
          .createExpense(widget.spaceId, _expense)
          .then((newExpense) {
        _setLoading(false);
        Provider.of<ExpensesListModel>(context, listen: false).addExpense(newExpense);
        Navigator.pop(context);
      });
    } else {
      widget.expensesTrackerApi.expenseApi.patchExpense(widget.spaceId, _expense).then((_) {
        _setLoading(false);
        Provider.of<ExpensesListModel>(context, listen: false).updateExpense(_expense);
        Navigator.pop(context, _expense);
      }).catchError((err) => print(err));
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
      _category = Provider.of<CategoriesListModel>(context, listen: false)
          .getCategoryById(_expense.category ?? '');
    }

    // Set the text from the TextEditingController
    _descriptionController.text = _expense.description;
    _costController.text = _expense.cost.toString();
  }

  void _onCategoryChanged(Category? newCategory) {
    setState(() {
      _category = newCategory;
    });
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
    final categories = [
      null,
      ...Provider.of<CategoriesListModel>(context, listen: false).categories,
    ];
    if (_firstBuild) {
      _firstBuild = false;
      _loadExpense(context);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_isNewExpense ? 'New expense' : _expense.description),
          leading: TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: () => _onSave(context),
            ),
          ],
        ),
        body: Stack(
          children: [
            Form(
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
                  FloatNumberFormField(
                    controller: _costController,
                    decoration: const InputDecoration(hintText: "Cost"),
                  ),
                  _CategoryDropdownButton(
                    dropdownValue: _category,
                    onChanged: _onCategoryChanged,
                  ),
                ],
              ),
            ),
            if (_isLoading) const ApiLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}

class _CategoryDropdownButton extends StatelessWidget {
  final Category? dropdownValue;
  final void Function(Category?) onChanged;

  const _CategoryDropdownButton({
    super.key,
    required this.dropdownValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Load categories
    final categories = [
      null,
      ...Provider.of<CategoriesListModel>(context, listen: false).categories,
    ];

    return DropdownButton<Category?>(
      value: dropdownValue,
      items: categories.map<DropdownMenuItem<Category?>>((Category? category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category != null ? category.title : 'None'),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
