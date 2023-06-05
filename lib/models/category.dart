/// Model for the Category
class Category {
  final String id;
  String title;

  /// Constructor
  Category({required this.id, required this.title});

  /// Constructor from a JSON
  Category.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['category_id'] ?? '',
        title = jsonData['category_title'] ?? '';
}
