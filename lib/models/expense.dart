class Expense {
  final String id;
  final double cost;
  final String description;
  final String date;
  final String category;
  final String paidBy;

  Expense(
      {required this.id,
      required this.cost,
      required this.description,
      required this.date,
      required this.category,
      required this.paidBy});

  Expense.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['expense_id'] ?? '',
        cost = (jsonData['expense_cost'] ?? 0.0).toDouble(),
        description = jsonData['expense_description'] ?? '',
        date = jsonData['expense_date'] ?? '',
        category = jsonData['expense_category'] ?? '',
        paidBy = jsonData['expense_paid_by'] ?? '';
}
