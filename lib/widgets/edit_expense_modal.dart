import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/category.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/general_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/api_loading_indicator.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/error_dialog.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/floatnumber_formfield.dart';

/// Show the modal to edit an [Expense]
Future<Expense?> showEditExpenseModal(BuildContext context, Space space, {String? expenseId}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ExpenseForm(
          spaceId: space.id,
          expenseId: expenseId,
        );
      });
}

/// Form to edit an expense
class ExpenseForm extends StatefulWidget {
  final String spaceId;
  final String? expenseId;

  /// Constructor
  const ExpenseForm({
    super.key,
    required this.spaceId,
    this.expenseId,
  });

  /// Override createState
  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

/// State for [ExpenseForm]
class _ExpenseFormState extends State<ExpenseForm> {
  bool _isLoading = false;
  bool _firstBuild = true;
  bool _isNewExpense = false;
  Category? _category;
  Expense _expense = Expense.defaultValues();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  /// Set [_isLoading]
  void _setLoading(bool loadingMode) => setState(() => _isLoading = loadingMode);

  /// Save the expense to the API
  void _onSave(BuildContext context) {
    // Check if the form is valid, return if its not
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get ExpensesTrackerApi from context
    final expensesTrackerApi = getExpensesTrackerApiModel(context).expensesTrackerApi;
    final expensesListModel = getExpensesListModel(context);

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

      expensesTrackerApi.expenseApi.createExpense(widget.spaceId, _expense).then((newExpense) {
        _setLoading(false);
        expensesListModel.addExpense(newExpense);
        Navigator.pop(context);
      }).catchError((err) => showErrorDialog(context, err));
    } else {
      expensesTrackerApi.expenseApi.patchExpense(widget.spaceId, _expense).then((_) {
        _setLoading(false);
        expensesListModel.updateExpense(_expense);
        Navigator.pop(context, _expense);
      }).catchError((err) => showErrorDialog(context, err));
    }
  }

  /// Load expense from [ExpensesListModel]
  void _loadExpense(BuildContext context) {
    // Check if the expense is a new one or you must update an existing one
    if (widget.expenseId == null) {
      _expense = Expense.defaultValues();
      _isNewExpense = true;
    } else {
      _expense = getExpensesListModel(context).getExpenseByID(widget.expenseId!) ??
          Expense.defaultValues();
      _category = getCategoriesListModel(context).getCategoryById(_expense.category ?? '');
    }

    // Set the text from the TextEditingController
    _descriptionController.text = _expense.description;
    _costController.text = _expense.cost.toString();
  }

  /// Callback used when the [Category] has changed
  void _onCategoryChanged(Category? newCategory) => setState(() => _category = newCategory);

  /// Dispose the widgets
  @override
  void dispose() {
    // Clear resources used by TextEditingController
    _descriptionController.dispose();
    _costController.dispose();

    super.dispose();
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    // If it is the first build, load the expense
    if (_firstBuild) {
      _firstBuild = false;
      _loadExpense(context);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leadingWidth: 80,
          title: Text(_isNewExpense ? 'New expense' : _expense.description),
          leading: TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
              softWrap: false,
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(hintText: "Expense description"),
                      validator: (text) {
                        return (text == null || text.isEmpty)
                            ? "Description cannot be empty!"
                            : null;
                      },
                    ),
                    FloatNumberFormField(
                      controller: _costController,
                      decoration: const InputDecoration(hintText: "Cost"),
                    ),
                    Row(
                      children: [
                        const Text('Category: ', style: TextStyle(fontSize: 15.0)),
                        _CategoryDropdownButton(
                          dropdownValue: _category,
                          onChanged: _onCategoryChanged,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (_isLoading) const ApiLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Create a [DropdownButton] to choose a [Category]
class _CategoryDropdownButton extends StatelessWidget {
  final Category? dropdownValue;
  final void Function(Category?) onChanged;

  /// Constructor
  const _CategoryDropdownButton({required this.dropdownValue, required this.onChanged});

  /// Override build
  @override
  Widget build(BuildContext context) {
    // Load categories
    final categories = [
      null,
      ...getCategoriesListModel(context).categories,
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
