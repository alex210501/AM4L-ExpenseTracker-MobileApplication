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

  /// Construct Space from JSON
  Space.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['space_id'] ?? '',
        name = jsonData['space_name'] ?? '',
        description = jsonData['space_description'] ?? '',
        admin = jsonData['space_admin'] ?? '',
        collaborators = (jsonData['space_collaborators'] ?? []).cast<String>();
}
