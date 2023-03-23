class User {
  final String username;
  final String firstname;
  final String lastname;
  final String email;

  User(
      {required this.username,
      required this.firstname,
      required this.lastname,
      required this.email});

  User.fromJson(Map<String, String> jsonData)
      : username = jsonData['username'] ?? '',
        firstname = jsonData['firstname'] ?? '',
        lastname = jsonData['lastname'] ?? '',
        email = jsonData['email'] ?? '';
}
