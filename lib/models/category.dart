class Category {
  final String id;
  String title;

  Category({required this.id, required this.title});

  Category.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['category_id'] ?? '',
        title = jsonData['category_title'] ?? '';
}
