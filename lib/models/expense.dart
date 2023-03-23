class Expense {
  final String id;
  final double cost;
  final String description;
  final DateTime date;
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
      : id = jsonData['id'] ?? '',
        cost = jsonData['cost'] ?? 0.0,
        description = jsonData['description'] ?? '',
        date = jsonData['date'] ?? DateTime.now(),
        category = jsonData['category'] ?? '',
        paidBy = jsonData['paydBy'] ?? '';
}
