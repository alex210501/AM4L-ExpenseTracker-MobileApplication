class User {
  final String username;
  final String firstname;
  final String lastname;
  final String email;

  User(
      {required this.username,
      required this.firstname,
      required this.lastname,
      required this.email });

  /// Create User from JSON
  User.fromJson(Map<dynamic, dynamic> jsonData)
      : username = jsonData['user_username'] ?? '',
        firstname = jsonData['user_firstname'] ?? '',
        lastname = jsonData['user_lastname'] ?? '',
        email = jsonData['user_email'] ?? '';

  /// Create JSON from User
  Map<String, dynamic> toJson() {
    return {
      'user_username': username,
      'user_firstname': firstname,
      'user_lastname': lastname,
      'user_email': email,
    };
  }
}
