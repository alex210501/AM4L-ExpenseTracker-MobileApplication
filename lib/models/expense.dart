/// Model for an Expense
class Expense {
  final String id;
  double cost;
  String description;
  DateTime date;
  String? category;
  final String paidBy;

  /// Constructor
  Expense(
      {required this.id,
      required this.cost,
      required this.description,
      required this.date,
      required this.category,
      required this.paidBy});

  /// Constructor from a JSON
  Expense.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['expense_id'] ?? '',
        cost = (jsonData['expense_cost'] ?? 0.0).toDouble(),
        description = jsonData['expense_description'] ?? '',
        date = DateTime.parse(jsonData['expense_date'] ?? ''),
        category = jsonData['expense_category'],
        paidBy = jsonData['expense_paid_by'] ?? '';

  /// Constructor with default values
  Expense.defaultValues()
      : id = '',
        cost = 0.0,
        description = '',
        date = DateTime.now(),
        category = '',
        paidBy = '';
}
