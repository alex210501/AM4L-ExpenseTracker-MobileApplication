class Space {
  final String id;
  final String name;
  final String description;
  final String admin;
  final List<String> collaborators;

  Space(
      {required this.id,
      required this.name,
      required this.description,
      required this.admin,
      required this.collaborators});

  Space.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'] ?? '',
        name = jsonData['name'] ?? '',
        description = jsonData['description'] ?? '',
        admin = jsonData['admin'] ?? '',
        collaborators = jsonData['collaborators'] ?? <String>[];
}
