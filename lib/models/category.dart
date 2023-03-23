class Category {
  final String id;
  final String title;

  Category({required this.id, required this.title});

  Category.fromJson(Map<String, String> jsonData)
      : id = jsonData['id'] ?? '',
        title = jsonData['title'] ?? '';
}
