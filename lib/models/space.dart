class Space {
  final String id;
  String name;
  String description;
  final String admin;
  final List<String> collaborators;

  Space(
      {required this.id,
      required this.name,
      required this.description,
      required this.admin,
      required this.collaborators});

  /// Constructor with default values
  Space.defaultValue()
      : id = '',
        name = '',
        description = '',
        admin = '',
        collaborators = [];

  /// Construct Space from JSON
  Space.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['space_id'] ?? '',
        name = jsonData['space_name'] ?? '',
        description = jsonData['space_description'] ?? '',
        admin = jsonData['space_admin'] ?? '',
        collaborators = (jsonData['space_collaborators'] ?? []).cast<String>();
}
